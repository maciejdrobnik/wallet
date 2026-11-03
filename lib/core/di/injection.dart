import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../features/subscriptions/data/repositories/subscription_repository_impl.dart';
import '../../features/subscriptions/domain/repositories/subscription_repository.dart';
import '../../features/subscriptions/domain/usecases/add_subscription.dart';
import '../../features/subscriptions/domain/usecases/calculate_monthly_total.dart';
import '../../features/subscriptions/domain/usecases/delete_subscription.dart';
import '../../features/subscriptions/domain/usecases/update_subscription.dart';
import '../../features/subscriptions/domain/usecases/watch_subscription.dart';
import '../database/app_database.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt
    ..registerLazySingleton<AppDatabase>(() => AppDatabase())
    ..registerLazySingleton<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(
        getIt<AppDatabase>().subscriptionsDao,
        now: DateTime.now,
      ),
    )
    ..registerFactory(
      () => AddSubscription(
        getIt<SubscriptionRepository>(),
        generateId: () => const Uuid().v4(),
        now: DateTime.now,
      ),
    )
    ..registerFactory(
      () => UpdateSubscription(
        getIt<SubscriptionRepository>(),
        now: DateTime.now,
      ),
    )
    ..registerFactory(() => DeleteSubscription(getIt<SubscriptionRepository>()))
    ..registerFactory(() => WatchSubscriptions(getIt<SubscriptionRepository>()))
    ..registerFactory(
      () => CalculateMonthlyTotal(getIt<SubscriptionRepository>()),
    );
}
