import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class UpdateSubscription {
  UpdateSubscription(this._repo, {required this._now});

  final SubscriptionRepository _repo;
  final DateTime Function() _now;

  Future<void> call(Subscription subscription) {
    return _repo.update(subscription.copyWith(updatedAt: _now().toUtc()));
  }
}
