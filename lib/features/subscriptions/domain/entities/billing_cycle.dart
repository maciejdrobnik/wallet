enum BillingCycle { monthly, yearly }

enum Category { entertainment, music, productivity, utilities, health, other, sport }

extension BillingCycleX on BillingCycle {
  int get paymentsPerYear => switch (this) {
    BillingCycle.monthly => 12,
    BillingCycle.yearly => 1,
  };
}
