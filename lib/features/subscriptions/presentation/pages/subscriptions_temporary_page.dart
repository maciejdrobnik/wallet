import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/billing_cycle.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/logic/next_payment_date.dart';
import '../../domain/usecases/add_subscription.dart';
import '../../domain/usecases/calculate_monthly_total.dart';
import '../../domain/usecases/delete_subscription.dart';
import '../../domain/usecases/update_subscription.dart';
import '../../domain/usecases/watch_subscription.dart';

class SubscriptionsTemporaryPage extends StatefulWidget {
  const SubscriptionsTemporaryPage({super.key});

  @override
  State<SubscriptionsTemporaryPage> createState() =>
      _SubscriptionsTemporaryPageState();
}

class _SubscriptionsTemporaryPageState
    extends State<SubscriptionsTemporaryPage> {
  late final Stream<List<Subscription>> _subs = getIt<WatchSubscriptions>()();
  late final Stream<Map<String, int>> _totals =
      getIt<CalculateMonthlyTotal>()();
  final _random = Random();
  int _counter = 1;

  Future<void> _addSample() async {
    final now = DateTime.now();
    await getIt<AddSubscription>()(
      name: 'Subskrypcja ${_counter++}',
      amount: 500 + _random.nextInt(5000),
      currency: 'PLN',
      cycle: _random.nextBool() ? BillingCycle.monthly : BillingCycle.yearly,
      category: Category.values[_random.nextInt(Category.values.length)],
      paymentDate: DateTime(now.year, now.month, 1 + _random.nextInt(28)),
    );
  }

  String _money(int minor, String currency) =>
      '${(minor / 100).toStringAsFixed(2)} $currency';

  String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet (debug)')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSample,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          StreamBuilder<Map<String, int>>(
            stream: _totals,
            builder: (context, snapshot) {
              final totals = snapshot.data ?? const <String, int>{};
              final text = totals.isEmpty
                  ? 'Miesięcznie: 0'
                  : 'Miesięcznie: ${totals.entries.map((e) => _money(e.value, e.key)).join(' + ')}';
              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<Subscription>>(
              stream: _subs,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Błąd: ${snapshot.error}'));
                }
                final subs = snapshot.data;
                if (subs == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (subs.isEmpty) {
                  return const Center(
                    child: Text('Brak wpisów. Dodaj pierwszy przyciskiem +'),
                  );
                }
                final today = DateTime.now();
                return ListView.builder(
                  itemCount: subs.length,
                  itemBuilder: (context, i) {
                    final s = subs[i];
                    final next = nextPaymentDate(
                      anchor: s.nextPaymentDate,
                      cycle: s.billingCycle,
                      today: today,
                    );
                    return Dismissible(
                      key: ValueKey(s.id),
                      background: Container(color: Colors.red),
                      onDismissed: (_) => getIt<DeleteSubscription>()(s.id),
                      child: ListTile(
                        title: Text(s.name),
                        subtitle: Text(
                          '${s.billingCycle.name} • ${s.category.name} • następna: ${_date(next)}',
                        ),
                        trailing: Text(_money(s.amount, s.currency)),
                        onTap: () => getIt<UpdateSubscription>()(
                          s.copyWith(amount: s.amount + 100),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
