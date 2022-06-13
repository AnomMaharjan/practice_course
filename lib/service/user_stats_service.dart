import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/model/subscription_status_model.dart';
import 'package:q4me/model/user_stats_model.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';

class UserStatService extends BaseController {
  ApiAuthProvider apiAuthProvider = ApiAuthProvider();
  SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  UserStats userStats;
  bool busy = false;
  bool firstTime = true;
  SubscriptionStatus subscriptionStatus;

  fetchSubscriptionStatus() async {
    subscriptionStatus = await apiAuthProvider.getSubscriptionStatus();
    if (subscriptionStatus != null) {
      if (subscriptionStatus.subscriptionStatus == false) {
        Future.delayed(Duration(seconds: 2), () {
          locator<UserStatService>().firstTime = true;
        });
        apiAuthProvider.logout();
        Get.offAllNamed(Routes.LOGIN_PAGE);
        locator<SharedPreferencesManager>().clearKey("username");
        locator<SharedPreferencesManager>().putBool("isLogin", false);
        locator<SharedPreferencesManager>().clearKey("userID");
        locator<SharedPreferencesManager>().clearKey("phonenumber");
        // locator<SharedPreferencesManager>().clearKey("accessToken");
        locator<SharedPreferencesManager>().clearKey("isCreditZero");
        locator<SharedPreferencesManager>().clearKey("callGoing");
        locator<SharedPreferencesManager>().getBool("isGoogleLogin") == true
            ? GoogleSignIn().signOut()
            : null;
        locator<UserStatService>().userStats = null;
        locator<SharedPreferencesManager>().putBool("isSubscribed", false);
        locator<SharedPreferencesManager>().putBool("isLoggedOut", true);
        locator<SharedPreferencesManager>().putInt("remainingCredit", 0);
        locator<SharedPreferencesManager>().putDouble("hoursSaved", 0.0);
        locator<SharedPreferencesManager>().clearKey("phoneNumberAdded");
        locator<SharedPreferencesManager>().clearKey("serviceId");
        sharedPreferencesManager.putBool("isSocial", false);

        update();
      }
    } else {
      locator<SharedPreferencesManager>().putBool("isSubscribed", true);
    }
  }

  fetchUserStatus() async {
    userStats = await apiAuthProvider.fetchUserStat();
    if (userStats != null) {
      sharedPreferencesManager.putInt(
          "remainingCredit", userStats.remainingCredits);
      sharedPreferencesManager.putDouble(
          "hoursSaved", userStats.totalHoursSaved);
      sharedPreferencesManager.putBool("isSocial", userStats.isSocial);

      if (userStats.remainingCredits <= 0) {
        sharedPreferencesManager.putBool("isCreditZero", true);
      } else {
        sharedPreferencesManager.putBool("isCreditZero", false);
      }
      if (userStats.subscriptionStatus == false) {}
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserStatus();
  }
}
