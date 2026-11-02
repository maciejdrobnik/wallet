import 'package:equatable/equatable.dart';

import 'billing_cycle.dart';

class Subscription extends Equatable {
  const Subscription({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.category,
    required this.nextPaymentDate,
    required this.updatedAt,
    this.isDeleted = false,
  });

  final String id;
  final String name;
  final int amount;
  final String currency;
  final BillingCycle billingCycle;
  final Category category;
  final DateTime nextPaymentDate;
  final DateTime updatedAt;
  final bool isDeleted;

  Subscription copyWith({
    String? id,
    String? name,
    int? amount,
    String? currency,
    BillingCycle? billingCycle,
    Category? category,
    DateTime? nextPaymentDate,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    amount,
    currency,
    billingCycle,
    category,
    nextPaymentDate,
    updatedAt,
    isDeleted,
  ];
}
