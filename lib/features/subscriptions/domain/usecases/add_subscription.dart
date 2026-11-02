import '../entities/billing_cycle.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class AddSubscription {
  AddSubscription(this._repo, {required this._generateId, required this._now});

  final SubscriptionRepository _repo;
  final String Function() _generateId;
  final DateTime Function() _now;

  Future<void> call({
    required String name,
    required int amount,
    required String currency,
    required BillingCycle cycle,
    required Category category,
    required DateTime paymentDate,
  }) {
    return _repo.add(
      Subscription(
        id: _generateId(),
        name: name.trim(),
        amount: amount,
        currency: currency,
        billingCycle: cycle,
        category: category,
        nextPaymentDate: paymentDate,
        // Should be moved to backend but not needed if user use app only locally and don't change time of the system
        updatedAt: _now().toUtc(),
      ),
    );
  }
}
