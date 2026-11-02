import '../entities/billing_cycle.dart';
import '../entities/subscription.dart';

Map<String, int> monthlyTotals(Iterable<Subscription> subs) {
  final annual = <String, int>{};
  for (final s in subs.where((s) => !s.isDeleted)) {
    final yearly = s.amount * s.billingCycle.paymentsPerYear;
    annual.update(s.currency, (v) => v + yearly, ifAbsent: () => yearly);
  }
  return annual.map((c, a) => MapEntry(c, (a / 12).round()));
}
