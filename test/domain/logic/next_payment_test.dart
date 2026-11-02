import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/features/subscriptions/domain/entities/billing_cycle.dart';
import 'package:wallet/features/subscriptions/domain/logic/next_payment_date.dart';

void main() {
  group('addMonths', () {
    test('ordinary case', () {
      expect(addMonths(DateTime(2025, 1, 15), 1), DateTime(2025, 2, 15));
    });

    test('31 january + 1 month in non-leap year', () {
      expect(addMonths(DateTime(2025, 1, 31), 1), DateTime(2025, 2, 28));
    });

    test('31 january + 1 month in leap year', () {
      expect(addMonths(DateTime(2024, 1, 31), 1), DateTime(2024, 2, 29));
    });

    test('moving between years', () {
      expect(addMonths(DateTime(2025, 11, 15), 3), DateTime(2026, 2, 15));
    });

    test('adding exactly one year', () {
      expect(addMonths(DateTime(2025, 6, 10), 12), DateTime(2026, 6, 10));
    });
  });

  group('nextPaymentDate', () {
    DateTime next(DateTime anchor, BillingCycle cycle, DateTime today) => nextPaymentDate(anchor: anchor, cycle: cycle, today: today);

    test('anchor in the future will return anchor', () {
      expect(next(DateTime(2025, 6, 1), BillingCycle.monthly, DateTime(2025, 2, 1)), DateTime(2025, 6, 1));
    });

    test('if today is payment today is returned', () {
      expect(next(DateTime(2025, 2, 10), BillingCycle.monthly, DateTime(2025, 2, 10)), DateTime(2025, 2, 10));
    });

    test('hour is ignored', () {
      expect(next(DateTime(2025, 2, 10), BillingCycle.monthly, DateTime(2025, 2, 10, 23, 59)), DateTime(2025, 2, 10));
    });

    test('if anchor is in past next month will be returned', () {
      expect(next(DateTime(2025, 1, 10), BillingCycle.monthly, DateTime(2025, 2, 11)), DateTime(2025, 3, 10));
    });

    test('anchor on 31 January case', () {
      final anchor = DateTime(2025, 1, 31);
      expect(next(anchor, BillingCycle.monthly, DateTime(2025, 2, 1)), DateTime(2025, 2, 28));
      expect(next(anchor, BillingCycle.monthly, DateTime(2025, 3, 1)), DateTime(2025, 3, 31));
    });

    test('between years', () {
      expect(next(DateTime(2025, 12, 15), BillingCycle.monthly, DateTime(2025, 12, 16)), DateTime(2026, 1, 15));
    });

    test('leap year case', () {
      final anchor = DateTime(2024, 2, 29);
      expect(next(anchor, BillingCycle.yearly, DateTime(2025, 1, 1)), DateTime(2025, 2, 28));
      expect(next(anchor, BillingCycle.yearly, DateTime(2028, 1, 1)), DateTime(2028, 2, 29));
    });

    test('Very old anchor case', () {
      expect(next(DateTime(2018, 3, 5), BillingCycle.monthly, DateTime(2025, 8, 20)), DateTime(2025, 9, 5));
    });
  });
}
