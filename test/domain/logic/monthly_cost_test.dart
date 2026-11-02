import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/features/subscriptions/domain/entities/billing_cycle.dart';
import 'package:wallet/features/subscriptions/domain/logic/monthly_cost.dart';

import '../helpers.dart';

void main() {
  group('monthlyTotals', () {
    test('empty list returns empty map', () {
      expect(monthlyTotals([]), isEmpty);
    });

    test('monthtly cost returns itself', () {
      final result = monthlyTotals([makeSub(amount: 1999)]);
      expect(result, {'PLN': 1999});
    });

    test('yearly is divided by 12', () {
      final result = monthlyTotals([makeSub(amount: 12000, cycle: BillingCycle.yearly)]);
      expect(result, {'PLN': 1000});
    });

    test('amount is rounded down when rest is lower than 0.5', () {
      final result = monthlyTotals([makeSub(amount: 1000, cycle: BillingCycle.yearly)]);
      expect(result, {'PLN': 83}); // 83.33
    });

    test('sums multiple subscriptions in same currency', () {
      final result = monthlyTotals([makeSub(id: 'a', amount: 1999), makeSub(id: 'b', amount: 12000, cycle: BillingCycle.yearly)]);
      expect(result, {'PLN': 2999});
    });

    test('round only at the end and not for every subscription', () {
      final result = monthlyTotals([makeSub(id: 'a', amount: 1000, cycle: BillingCycle.yearly), makeSub(id: 'b', amount: 1000, cycle: BillingCycle.yearly)]);
      expect(result, {'PLN': 167});
    });

    test('different currencies are not summed', () {
      final result = monthlyTotals([makeSub(id: 'a', amount: 1000, currency: 'PLN'), makeSub(id: 'b', amount: 500, currency: 'USD')]);
      expect(result, {'PLN': 1000, 'USD': 500});
    });

    test('skipping deleted subscriptions', () {
      final result = monthlyTotals([makeSub(id: 'a', amount: 1000), makeSub(id: 'b', amount: 9999, isDeleted: true)]);
      expect(result, {'PLN': 1000});
    });
  });
}
