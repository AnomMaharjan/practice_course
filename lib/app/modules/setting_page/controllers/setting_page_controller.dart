import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/modules/call_tracker/bindings/call_tracker_binding.dart';
import 'package:q4me/app/modules/call_tracker/views/call_tracker_view.dart';
import 'package:q4me/app/modules/configuration_page/bindings/configuration_page_binding.dart';
import 'package:q4me/app/modules/configuration_page/views/configuration_page_view.dart';
import 'package:q4me/app/modules/live_chat_page/bindings/live_chat_page_binding.dart';
import 'package:q4me/app/modules/live_chat_page/views/live_chat_page_view.dart';
import 'package:q4me/app/modules/login_page/bindings/login_page_binding.dart';
import 'package:q4me/app/modules/login_page/views/login_page_view.dart';
import 'package:q4me/app/modules/new_faq/bindings/new_faq_binding.dart';
import 'package:q4me/app/modules/new_faq/views/new_faq_view.dart';
import 'package:q4me/app/modules/profile_page/bindings/profile_page_binding.dart';
import 'package:q4me/app/modules/profile_page/views/profile_page_view.dart';
import 'package:q4me/app/modules/time_breakdown/bindings/time_breakdown_binding.dart';
import 'package:q4me/app/modules/time_breakdown/views/time_breakdown_view.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/service/user_stats_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/globals/globals.dart' as globals;

class SettingPageController extends BaseController with Connection {
  final AnalyticsService analytics = locator<AnalyticsService>();
  final ApiAuthProvider _apiAuthProvider = Get.put(ApiAuthProvider());

  List settingList;
  var loading = false.obs;

  void onLogOut() async {
    loading.value = true;
    var response = await _apiAuthProvider.logout();
    if (response == true) {
      Future.delayed(Duration(seconds: 2), () {
        analytics.logEvent("logout_clicked", "user logged out}");

        globals.currentIndex.value = 0;
        locator<UserStatService>().firstTime = true;
      });
      Get.offAll(() => LoginPageView(), binding: LoginPageBinding());
      locator<SharedPreferencesManager>().clearKey("username");
      locator<SharedPreferencesManager>().putBool("isLogin", false);
      locator<SharedPreferencesManager>().clearKey("userID");
      locator<SharedPreferencesManager>().clearKey("phonenumber");
      locator<SharedPreferencesManager>().clearKey("accessToken");
      locator<SharedPreferencesManager>().clearKey("isCreditZero");
      locator<SharedPreferencesManager>().clearKey("callGoing");
      locator<SharedPreferencesManager>().putBool("userInfoUpdated", false);
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
      locator<SharedPreferencesManager>().clearKey("callfailed");
      _apiAuthProvider.clearCache();
      update();
      loading.value = false;
    } else {
      Get.snackbar("Error!", "Something went wrong. Could not logout.");
      loading.value = false;
      update();
    }
    update();
  }

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
    settingList = [
      [
        "assets/svgs/profile1.svg",
        "profile",
        () async {
          await analytics.logEvent("profile_clicked", "Clicked profile}");
          Get.to(() => ProfilePageView(),
              transition: Transition.cupertino, binding: ProfilePageBinding());
        }
      ],
      [
        "assets/svgs/call-tracker.svg",
        "call tracker",
        () {
          analytics.logEvent("call_tracker_clicked", "Clicked call_tracker}");
          Get.to(() => CallTrackerView(),
              arguments: {"from": 1},
              transition: Transition.cupertino,
              binding: CallTrackerBinding());
        }
      ],
      [
        "assets/svgs/breakdown.svg",
        "breakdown",
        () async {
          Get.to(
              () => TimeBreakdownView(
                    from: 1,
                  ),
              binding: TimeBreakdownBinding());
          await analytics.logEvent(
              "time_breakdown_clicked", "Clicked time breakdown}");
        }
      ],
      [
        "assets/svgs/configuration.svg",
        "configuration",
        () async {
          Get.to(() => ConfigurationPageView(),
              binding: ConfigurationPageBinding());
          await analytics.logEvent(
              "configuration_clicked", "Clicked configuration}");
        },
      ],
      [
        "assets/svgs/message1.svg",
        "faqs",
        () async {
          Get.to(
            () => NewFaqView(),
            binding: NewFaqBinding(),
            transition: Transition.cupertino,
          );
          await analytics.logEvent("faq_clicked", "Clicked faq}");
        }
      ],
      [
        "assets/svgs/chat.svg",
        "chat support",
        () async {
          Get.to(
            () => LiveChatPageView(),
            binding: LiveChatPageBinding(),
            transition: Transition.cupertino,
          );
          await analytics.logEvent(
              "chat_support_clicked", "Clicked chat support}");
        }
      ],
      ["assets/svgs/logout.svg", "logout", null],
    ];
  }
}
