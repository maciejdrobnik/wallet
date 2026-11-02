import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallet/features/subscriptions/domain/entities/subscription.dart';
import 'package:wallet/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:wallet/features/subscriptions/domain/usecases/delete_subscription.dart';
import 'package:wallet/features/subscriptions/domain/usecases/update_subscription.dart';

import '../helpers.dart';

class MockRepo extends Mock implements SubscriptionRepository {}

void main() {
  late MockRepo repo;

  setUpAll(() => registerFallbackValue(makeSub()));
  setUp(() => repo = MockRepo());

  test('UpdateSubscription refresh updateAt', () async {
    when(() => repo.update(any())).thenAnswer((_) async {});
    final update = UpdateSubscription(
      repo,
      now: () => DateTime.utc(2025, 6, 1),
    );

    await update(makeSub(name: 'Spotify', updatedAt: DateTime.utc(2025, 1, 1)));

    final saved =
        verify(() => repo.update(captureAny())).captured.single as Subscription;
    expect(saved.name, 'Spotify');
    expect(saved.updatedAt, DateTime.utc(2025, 6, 1));
  });

  test('DeleteSubscription delete', () async {
    when(() => repo.delete(any())).thenAnswer((_) async {});

    await DeleteSubscription(repo)('id-42');

    verify(() => repo.delete('id-42')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
