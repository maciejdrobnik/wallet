import 'package:equatable/equatable.dart';

import 'subscription.dart';

class UpcomingPayment extends Equatable {
  const UpcomingPayment({required this.subscription, required this.date});

  final Subscription subscription;
  final DateTime date;

  @override
  List<Object?> get props => [subscription, date];
}
