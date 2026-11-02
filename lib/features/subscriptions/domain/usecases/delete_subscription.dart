import '../repositories/subscription_repository.dart';

class DeleteSubscription {
  DeleteSubscription(this._repo);
  final SubscriptionRepository _repo;

  Future<void> call(String id) => _repo.delete(id);
}
