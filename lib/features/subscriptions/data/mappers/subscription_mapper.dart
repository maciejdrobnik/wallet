import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/billing_cycle.dart';
import '../../domain/entities/subscription.dart';

extension SubscriptionRowX on SubscriptionRow {
  Subscription toEntity() => Subscription(
    id: id,
    name: name,
    amount: amount,
    currency: currency,
    billingCycle: BillingCycle.values.byName(billingCycle),
    category: Category.values.byName(category),
    nextPaymentDate: nextPaymentDate,
    updatedAt: updatedAt.toUtc(),
    isDeleted: isDeleted,
  );
}

extension SubscriptionToDb on Subscription {
  SubscriptionsCompanion toCompanion() => SubscriptionsCompanion.insert(
    id: id,
    name: name,
    amount: amount,
    currency: currency,
    billingCycle: billingCycle.name,
    category: category.name,
    nextPaymentDate: nextPaymentDate,
    updatedAt: updatedAt,
    isDeleted: Value(isDeleted),
  );
}
