import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../local/subscriptions_dao.dart';
import '../mappers/subscription_mapper.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._dao, {required this._now});

  final SubscriptionsDao _dao;
  final DateTime Function() _now;

  @override
  Stream<List<Subscription>> watchAll() =>
      _dao.watchActive().map((rows) => rows.map((r) => r.toEntity()).toList());

  @override
  Future<Subscription?> getById(String id) async =>
      (await _dao.getById(id))?.toEntity();

  @override
  Future<void> add(Subscription subscription) =>
      _dao.upsert(subscription.toCompanion());

  @override
  Future<void> update(Subscription subscription) =>
      _dao.upsert(subscription.toCompanion());

  @override
  Future<void> delete(String id) => _dao.softDelete(id, _now().toUtc());
}
