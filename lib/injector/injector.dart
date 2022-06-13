import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/service/connectivit_service.dart';
import 'package:q4me/service/user_stats_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  SharedPreferencesManager sharedPreferencesManager =
      await SharedPreferencesManager.getInstance();
  locator.registerSingleton<SharedPreferencesManager>(sharedPreferencesManager);
  locator.registerSingleton<UserStatService>(UserStatService());
  locator.registerSingleton<AnalyticsService>(AnalyticsService());
  locator.registerSingleton<ConnectivityService>(ConnectivityService());
}
