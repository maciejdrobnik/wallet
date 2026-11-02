import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class WatchSubscriptions {
  WatchSubscriptions(this._repo);
  final SubscriptionRepository _repo;

  Stream<List<Subscription>> call() => _repo.watchAll();
}
