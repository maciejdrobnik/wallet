import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/features/subscriptions/domain/entities/billing_cycle.dart';

void main() {
  group('BillingCycle.paymentsPerYear', () {
    test('montly means 12 payments', () {
      expect(BillingCycle.monthly.paymentsPerYear, 12);
    });
    test('yearly means 1 payment', () {
      expect(BillingCycle.yearly.paymentsPerYear, 1);
    });
  });
}
