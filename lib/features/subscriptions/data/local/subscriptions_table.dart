import 'package:drift/drift.dart';

@DataClassName('SubscriptionRow')
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get amount => integer()();
  TextColumn get currency => text().withLength(min: 3, max: 3)();
  TextColumn get billingCycle => text()();
  TextColumn get category => text()();
  DateTimeColumn get nextPaymentDate => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
