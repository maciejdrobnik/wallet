import '../logic/monthly_cost.dart';
import '../repositories/subscription_repository.dart';

class CalculateMonthlyTotal {
  CalculateMonthlyTotal(this._repo);
  final SubscriptionRepository _repo;

  Stream<Map<String, int>> call() => _repo.watchAll().map(monthlyTotals);
}
