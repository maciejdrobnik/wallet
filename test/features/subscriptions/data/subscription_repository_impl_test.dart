import 'package:async/async.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/core/database/app_database.dart';
import 'package:wallet/features/subscriptions/data/repositories/subscription_repository_impl.dart';

import '../../../domain/helpers.dart';

void main() {
  late AppDatabase db;
  late SubscriptionRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SubscriptionRepositoryImpl(
      db.subscriptionsDao,
      now: () => DateTime.utc(2025, 6, 1),
    );
  });

  tearDown(() => db.close());

  test(
    'added subscription is correctly saved and immediately enable to fetch',
    () async {
      final sub = makeSub();
      await repo.add(sub);

      expect(await repo.getById(sub.id), equals(sub));
    },
  );

  test('updatedAt returns as a UTC date', () async {
    await repo.add(makeSub());

    final loaded = await repo.getById('id-1');
    expect(loaded!.updatedAt.isUtc, isTrue);
  });

  test('getById returns null for non-existing id', () async {
    expect(await repo.getById('brak'), isNull);
  });

  test('update changes existing entry', () async {
    await repo.add(makeSub(name: 'Netflix'));
    await repo.update(makeSub(name: 'Spotify'));

    final all = await repo.watchAll().first;
    expect(all, hasLength(1));
    expect(all.single.name, 'Spotify');
  });

  test('delete hides but do not remove entry', () async {
    await repo.add(makeSub());
    await repo.delete('id-1');

    expect(await repo.watchAll().first, isEmpty);

    final rows = await db.select(db.subscriptions).get();
    expect(rows.single.isDeleted, isTrue);
    expect(rows.single.updatedAt.toUtc(), DateTime.utc(2025, 6, 1));
  });

  test('watchAll refreshes after adding new entry', () async {
    final queue = StreamQueue(repo.watchAll());
    addTearDown(queue.cancel);

    expect(await queue.next, isEmpty);
    await repo.add(makeSub());
    expect(await queue.next, hasLength(1));
  });

  test('list is sorted', () async {
    await repo.add(makeSub(id: 'b', name: 'Zeta'));
    await repo.add(makeSub(id: 'a', name: 'Alfa'));

    final names = (await repo.watchAll().first).map((s) => s.name);
    expect(names, ['Alfa', 'Zeta']);
  });
}
