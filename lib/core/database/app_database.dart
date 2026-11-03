import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/subscriptions/data/local/subscriptions_dao.dart';
import '../../features/subscriptions/data/local/subscriptions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Subscriptions], daos: [SubscriptionsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'wallet'));

  @override
  int get schemaVersion => 1;
}
