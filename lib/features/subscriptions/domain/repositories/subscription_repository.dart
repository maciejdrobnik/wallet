import '../entities/subscription.dart';

abstract interface class SubscriptionRepository {
  Stream<List<Subscription>> watchAll();

  Future<Subscription?> getById(String id);

  Future<void> add(Subscription subscription);

  Future<void> update(Subscription subscription);

  Future<void> delete(String id);
}
