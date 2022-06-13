import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/phone_number_response.dart';
import 'package:q4me/service/user_stats_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'package:q4me/utils/string.dart';

class TrialPageController extends BaseController with Connection {
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider();
  final SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  Offerings offerings;
  List<Package> package;
  BuildContext contexts;
  bool loading = false;
  bool termsAndConditions = false;
  bool privacyPolicy = false;
  String termsAndConditionsLink = "https://www.q4me.co.uk/terms-conditions/";
  String privacyPolicyLink = "https://www.q4me.co.uk/privacy-policy/";
  final TextEditingController phoneNumberController = TextEditingController();
  PhoneNumberResponse phoneNumberResponse;
  bool isLoading = false;
  final ApiAuthProvider apiAuthProvider = ApiAuthProvider();

  initialize(BuildContext context) {
    contexts = context;
    update();
  }

  Future<void> initRevenueCatPlatformState() async {
    loading = true;
    if (Platform.isIOS) {
      await Purchases.setup(Config.APPLE_SECRET_KEY,
          observerMode: false,
          appUserId: locator<SharedPreferencesManager>().getString("username"));
    } else {
      await Purchases.setup(Config.GOOGLE_SECRET_KEY,
          observerMode: false,
          appUserId: locator<SharedPreferencesManager>().getString("username"));
    }
    await Purchases.setDebugLogsEnabled(true);
    checkProducts();
  }

  void checkProducts() async {
    try {
      offerings = await Purchases.getOfferings();
      print("offerings fetched");
      print('offerings: ${offerings.current}');
      print('all ${offerings.all}');
      if (offerings.current != null &&
          offerings.current.availablePackages.isNotEmpty) {
        package = offerings.current.availablePackages.toList();

        loading = false;
        update();
      } else
        loading = false;
      update();
    } on PlatformException catch (e) {
      // optional error handling
      Get.snackbar("Error", "${e.message}");
      loading = false;
      update();
      print(e);
    }
  }

  void checkTermsAndConditions(bool value) {
    termsAndConditions = value;
    update();
    print('terms: ${termsAndConditions}');
  }

  void checkPrivacyPolicy(bool value) {
    privacyPolicy = value;
    update();
    print('privacy: ${privacyPolicy}');
  }

  void onClosePressed() {
    apiAuthProvider.logout();
    locator<SharedPreferencesManager>().putBool("isLoggedOut", true);
    locator<SharedPreferencesManager>().putBool("isSubscribed", false);
    locator<SharedPreferencesManager>().clearKey("username");
    locator<SharedPreferencesManager>().clearKey("isLogin");
    locator<SharedPreferencesManager>().clearKey("userID");
    locator<SharedPreferencesManager>().clearKey("phonenumber");
    locator<SharedPreferencesManager>().clearKey("accessToken");
    locator<SharedPreferencesManager>().clearKey("isCreditZero");
    locator<SharedPreferencesManager>().clearKey("callGoing");
    locator<SharedPreferencesManager>().getBool("isGoogleLogin") == true
        ? GoogleSignIn().signOut()
        : null;
    locator<UserStatService>().userStats = null;
    locator<SharedPreferencesManager>().putInt("remainingCredit", 0);
    locator<SharedPreferencesManager>().putDouble("hoursSaved", 0.0);
    locator<SharedPreferencesManager>().clearKey("phoneNumberAdded");
    locator<SharedPreferencesManager>().clearKey("serviceId");
    locator<SharedPreferencesManager>().clearKey("callfailed");
    _apiAuthProvider.clearCache();
    Purchases.logOut();

    update();

    Future.delayed(Duration(milliseconds: 500), () {
      exit(0);
    });
  }

  void acceptTermsAndConditions() async {
    isLoading = true;
    Map map = {
      "accept_terms_and_condition": termsAndConditions,
      "accept_privacy_policy": privacyPolicy
    };
    bool response = await _apiAuthProvider.acceptTermsAndConditions(body: map);
    if (response == true) {
      purchase();
    } else {
      Get.snackbar("Error", "Something went wrong.");
    }
  }

  void purchase() async {
    setState(ViewState.Busy);
    try {
      print("secret key: ${Config.APPLE_SECRET_KEY}");
      print('offerringgssss : ${offerings.current.availablePackages[0]}');
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(
          offerings.current.availablePackages[0]);
      Purchases.syncPurchases();

      print('active subscriptions: ${purchaserInfo.activeSubscriptions}');
      loading = false;
      update();
      if (Platform.isIOS) {
        if (purchaserInfo.entitlements.all["one credit per month"].isActive) {
          sharedPreferencesManager.putBool("isSubscribed", true);

          setState(ViewState.Retrieved);

          Get.offAllNamed(Routes.PROFILE_INFORMATION_PAGE);
        } else {
          setState(ViewState.Retrieved);
          Get.snackbar(
              'Invalid Purchase!', 'Could not complete the subscription.',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        if (purchaserInfo.entitlements.all["one credit per month"].isActive) {
          sharedPreferencesManager.putBool("isSubscribed", true);
          setState(ViewState.Retrieved);
          Get.offAllNamed(Routes.PROFILE_INFORMATION_PAGE);
        } else {
          setState(ViewState.Retrieved);
          Get.snackbar(
              'Invalid Purchase!', 'Could not complete the subscription.',
              snackPosition: SnackPosition.TOP);
        }
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      setState(ViewState.Retrieved);
      Get.snackbar('Invalid Purchase!', 'Could not complete the subscription.',
          snackPosition: SnackPosition.TOP);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print('error $e');
      }
      if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        Get.snackbar("Product already purchased", "error");
        loading = false;
        update();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    locator<SharedPreferencesManager>().putBool("userInfoUpdated", false);
    initRevenueCatPlatformState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }
}
