import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallet/features/subscriptions/domain/entities/billing_cycle.dart';
import 'package:wallet/features/subscriptions/domain/entities/subscription.dart';
import 'package:wallet/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:wallet/features/subscriptions/domain/usecases/add_subscription.dart';

import '../helpers.dart';

class MockRepo extends Mock implements SubscriptionRepository {}

void main() {
  late MockRepo repo;
  late AddSubscription addSubscription;

  setUpAll(() => registerFallbackValue(makeSub()));

  setUp(() {
    repo = MockRepo();
    when(() => repo.add(any())).thenAnswer((_) async {});
    addSubscription = AddSubscription(
      repo,
      generateId: () => 'id-1',
      now: () => DateTime.utc(2025, 1, 1),
    );
  });

  test('Add new subscription', () async {
    await addSubscription(
      name: '  Netflix  ',
      amount: 4300,
      currency: 'PLN',
      cycle: BillingCycle.monthly,
      category: Category.entertainment,
      paymentDate: DateTime(2025, 2, 10),
    );

    final saved =
        verify(() => repo.add(captureAny())).captured.single as Subscription;

    expect(saved.id, 'id-1');
    expect(saved.name, 'Netflix');
    expect(saved.amount, 4300);
    expect(saved.nextPaymentDate, DateTime(2025, 2, 10));
    expect(saved.updatedAt, DateTime.utc(2025, 1, 1));
    expect(saved.isDeleted, isFalse);
  });

  test('verification if add was called only once', () async {
    await addSubscription(
      name: 'Netflix',
      amount: 4300,
      currency: 'PLN',
      cycle: BillingCycle.monthly,
      category: Category.entertainment,
      paymentDate: DateTime(2025, 2, 10),
    );

    verify(() => repo.add(any())).called(1);
    verifyNoMoreInteractions(repo);
  });
}
