import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/features/subscriptions/domain/entities/billing_cycle.dart';

import '../helpers.dart';

void main() {
  group('equality', () {
    test('2 same objects are equal', () {
      expect(makeSub(), equals(makeSub()));
    });

    test('different id means different objects', () {
      expect(makeSub(id: 'a'), isNot(equals(makeSub(id: 'b'))));
    });

    test('different amount means different objects', () {
      expect(makeSub(amount: 100), isNot(equals(makeSub(amount: 200))));
    });
  });

  group('copyWith', () {
    test('copyWith without arguments return itself ', () {
      final sub = makeSub();
      expect(sub.copyWith(), equals(sub));
    });

    test('changes only specified fields', () {
      final sub = makeSub();
      final changed = sub.copyWith(name: 'Spotify');

      expect(changed.name, 'Spotify');
      expect(changed.id, sub.id);
      expect(changed.amount, sub.amount);
      expect(changed.category, sub.category);
    });

    test("doesn't change original object", () {
      final sub = makeSub();
      sub.copyWith(category: Category.music);
      expect(sub.category, Category.entertainment);
    });
  });

  test('isDeleted is false by default', () {
    expect(makeSub().isDeleted, isFalse);
  });
}
