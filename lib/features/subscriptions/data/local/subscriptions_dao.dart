import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import 'subscriptions_table.dart';

part 'subscriptions_dao.g.dart';

@DriftAccessor(tables: [Subscriptions])
class SubscriptionsDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionsDaoMixin {
  SubscriptionsDao(super.db);

  /// Aktywne wpisy, posortowane po nazwie. Strumień odświeża się sam.
  Stream<List<SubscriptionRow>> watchActive() {
    return (select(subscriptions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<SubscriptionRow?> getById(String id) {
    return (select(
      subscriptions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsert(SubscriptionsCompanion entry) {
    return into(subscriptions).insertOnConflictUpdate(entry);
  }

  Future<void> softDelete(String id, DateTime now) {
    return (update(subscriptions)..where((t) => t.id.equals(id))).write(
      SubscriptionsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }
}
