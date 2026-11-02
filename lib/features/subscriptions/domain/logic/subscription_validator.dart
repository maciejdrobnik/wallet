enum SubscriptionError { nameEmpty, amountNotPositive, currencyInvalid, paymentDayTooLate }

Set<SubscriptionError> validateSubscription({required String name, required int amountMinor, required String currency, required DateTime paymentDate}) => {
  if (name.trim().isEmpty) SubscriptionError.nameEmpty,
  if (amountMinor <= 0) SubscriptionError.amountNotPositive,
  if (currency.length != 3) SubscriptionError.currencyInvalid,
  // For now I am skipping case of payments after 28th of month
  if (paymentDate.day > 28) SubscriptionError.paymentDayTooLate,
};
