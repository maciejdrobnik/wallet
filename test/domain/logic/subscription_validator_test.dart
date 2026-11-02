import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/features/subscriptions/domain/logic/subscription_validator.dart';

void main() {
  Set<SubscriptionError> validate({String name = 'Netflix', int amountMinor = 4300, String currency = 'PLN', DateTime? paymentDate}) =>
      validateSubscription(name: name, amountMinor: amountMinor, currency: currency, paymentDate: paymentDate ?? DateTime(2025, 2, 10));

  test('valid data', () {
    expect(validate(), isEmpty);
  });

  test('empty name', () {
    expect(validate(name: ''), {SubscriptionError.nameEmpty});
  });

  test('only spaces', () {
    expect(validate(name: '   '), {SubscriptionError.nameEmpty});
  });

  test('amount equals 0', () {
    expect(validate(amountMinor: 0), {SubscriptionError.amountNotPositive});
  });

  test('negative amount', () {
    expect(validate(amountMinor: -100), {SubscriptionError.amountNotPositive});
  });

  test('waluta o złej długości', () {
    expect(validate(currency: 'PL'), {SubscriptionError.currencyInvalid});
  });

  test('correct date', () {
    expect(validate(paymentDate: DateTime(2025, 2, 28)), isEmpty);
  });

  test('day of a month after 28', () {
    expect(validate(paymentDate: DateTime(2025, 3, 29)), {SubscriptionError.paymentDayTooLate});
  });

  test('few errors at once', () {
    expect(validate(name: '', amountMinor: 0), {SubscriptionError.nameEmpty, SubscriptionError.amountNotPositive});
  });
}
