import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallet/features/subscriptions/domain/entities/upcoming_payment.dart';
import 'package:wallet/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:wallet/features/subscriptions/domain/usecases/get_upcoming_payments.dart';

import '../helpers.dart';

class MockRepo extends Mock implements SubscriptionRepository {}

void main() {
  late MockRepo repo;
  late GetUpcomingPayments getUpcoming;

  setUp(() {
    repo = MockRepo();
    getUpcoming = GetUpcomingPayments(repo, now: () => DateTime(2025, 3, 20));
  });

  test('test sorting payments', () async {
    final late = makeSub(id: 'late', nextPaymentDate: DateTime(2025, 1, 25));
    final soon = makeSub(id: 'soon', nextPaymentDate: DateTime(2025, 1, 22));
    when(() => repo.watchAll()).thenAnswer((_) => Stream.value([late, soon]));

    final result = await getUpcoming().first;

    expect(result, [
      UpcomingPayment(subscription: soon, date: DateTime(2025, 3, 22)),
      UpcomingPayment(subscription: late, date: DateTime(2025, 3, 25)),
    ]);
  });

  test('today counted as payment', () async {
    final sub = makeSub(nextPaymentDate: DateTime(2025, 1, 20));
    when(() => repo.watchAll()).thenAnswer((_) => Stream.value([sub]));

    final result = await getUpcoming().first;

    expect(result.single.date, DateTime(2025, 3, 20));
  });

  test('filtering by date', () async {
    final near = makeSub(id: 'near', nextPaymentDate: DateTime(2025, 1, 22));
    final far = makeSub(id: 'far', nextPaymentDate: DateTime(2025, 1, 10));
    when(() => repo.watchAll()).thenAnswer((_) => Stream.value([near, far]));

    final result = await getUpcoming(withinDays: 7).first;

    expect(result.map((p) => p.subscription.id), ['near']);
  });

  test('empty list', () async {
    when(() => repo.watchAll()).thenAnswer((_) => Stream.value([]));

    expect(await getUpcoming().first, isEmpty);
  });
}
