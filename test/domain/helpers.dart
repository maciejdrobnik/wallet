import 'package:wallet/features/subscriptions/domain/entities/billing_cycle.dart';
import 'package:wallet/features/subscriptions/domain/entities/subscription.dart';

Subscription makeSub({
  String id = 'id-1',
  String name = 'Netflix',
  int amount = 4300,
  String currency = 'PLN',
  BillingCycle cycle = BillingCycle.monthly,
  Category category = Category.entertainment,
  DateTime? nextPaymentDate,
  DateTime? updatedAt,
  bool isDeleted = false,
}) {
  return Subscription(
    id: id,
    name: name,
    amount: amount,
    currency: currency,
    billingCycle: cycle,
    category: category,
    nextPaymentDate: nextPaymentDate ?? DateTime(2025, 2, 10),
    updatedAt: updatedAt ?? DateTime.utc(2025, 1, 1),
    isDeleted: isDeleted,
  );
}
