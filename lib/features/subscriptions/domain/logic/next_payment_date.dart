import 'dart:math' as math;

import '../entities/billing_cycle.dart';

DateTime addMonths(DateTime d, int months) {
  final total = d.year * 12 + (d.month - 1) + months;
  final year = total ~/ 12;
  final month = total % 12 + 1;
  final lastDayOfMonth = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, math.min(d.day, lastDayOfMonth));
}

DateTime _occurrence(DateTime anchor, BillingCycle cycle, int n) {
  return switch (cycle) {
    BillingCycle.monthly => addMonths(anchor, n),
    BillingCycle.yearly => addMonths(anchor, 12 * n),
  };
}

DateTime nextPaymentDate({
  required DateTime anchor,
  required BillingCycle cycle,
  required DateTime today,
}) {
  final startOfToday = DateTime(today.year, today.month, today.day);
  final anchorDay = DateTime(anchor.year, anchor.month, anchor.day);

  var n = 0;
  var candidate = _occurrence(anchorDay, cycle, n);
  while (candidate.isBefore(startOfToday)) {
    n++;
    candidate = _occurrence(anchorDay, cycle, n);
  }
  return candidate;
}
