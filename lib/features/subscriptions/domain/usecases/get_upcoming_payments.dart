import '../entities/upcoming_payment.dart';
import '../logic/next_payment_date.dart';
import '../repositories/subscription_repository.dart';

class GetUpcomingPayments {
  GetUpcomingPayments(this._repo, {required this._now});

  final SubscriptionRepository _repo;
  final DateTime Function() _now;

  Stream<List<UpcomingPayment>> call({int? withinDays}) {
    return _repo.watchAll().map((subs) {
      final now = _now();
      final today = DateTime(now.year, now.month, now.day);

      final payments =
          subs
              .map(
                (s) => UpcomingPayment(
                  subscription: s,
                  date: nextPaymentDate(
                    anchor: s.nextPaymentDate,
                    cycle: s.billingCycle,
                    today: today,
                  ),
                ),
              )
              .where(
                (p) =>
                    withinDays == null ||
                    p.date.difference(today).inDays <= withinDays,
              )
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));

      return payments;
    });
  }
}
