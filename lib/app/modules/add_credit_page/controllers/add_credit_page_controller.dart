import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/additional_credits_model.dart';
import 'package:q4me/service/user_stats_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'dart:developer' as dev;
import 'package:q4me/globals/globals.dart' as globals;

class AddCreditPageController extends BaseController with Connection {
  var topup = false.obs;
  var addCredit = false.obs;
  final UserStatService userStatService = locator<UserStatService>();
  var selectedCredit = 0.obs;
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider();

  bool loading = false; //checks the viewstate condition of the controller
  bool purchasing = false; //checks if product is still being purchased
  PurchaserInfo purchaserInfo;
  Offerings offerings;
  PurchaserInfo successIos;
  PurchaserInfo successAndroid;
  final Connectivity _connectivity = Connectivity();
  String termsAndConditionsLink = "https://www.q4me.co.uk/terms-conditions/";
  String privacyPolicyLink = "https://www.q4me.co.uk/privacy-policy/";
  List<AdditionalCredits> additionalCredits = [];

  void selectCredit(int credit) {
    selectedCredit.value = credit;
    print(selectedCredit.value);
  }

  void updateTopupStatus(bool value) {
    topup.value = value;
    update();
  }

  void getAdditionalCredits() async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(ViewState.Busy);
      additionalCredits = await _apiAuthProvider.fetchAdditionalCredits();
      if (additionalCredits == null) setState(ViewState.Retrieved);
      setState(ViewState.Retrieved);
    } else {
      Fluttertoast.showToast(msg: "Device Not Connected to the Internet.");
    }
  }

  Future<void> initPlatformState() async {
    if (Platform.isIOS) {
      await Purchases.setup(
        Config.APPLE_SECRET_KEY,
        observerMode: false,
        appUserId: locator<SharedPreferencesManager>().getString("username"),
      );
    } else {
      await Purchases.setup(Config.GOOGLE_SECRET_KEY,
          observerMode: false,
          appUserId: locator<SharedPreferencesManager>().getString("username"));
    }

    await Purchases.setDebugLogsEnabled(true);
    purchaserInfo = await Purchases.getPurchaserInfo();
    dev.log("purchaser info: $purchaserInfo");
    dev.log("purchaserr: ${purchaserInfo.allPurchasedProductIdentifiers}");
    fetchOfferings();
  }

  Future<void> fetchOfferings() async {
    try {
      offerings = await Purchases.getOfferings();

      if (offerings.current != null &&
          offerings.current.availablePackages.isNotEmpty) {
        // Display packages for sale
        dev.log('this is offerings all ${offerings}');
        dev.log("products: ${offerings.all}");
        update();
      }
    } on PlatformException catch (e) {
      // Get.snackbar("error", e.toString());
      print("error loading packages ${e.message}");
      update();
    }
  }

  getUserStatus() async {
    await userStatService.fetchUserStatus();
    update();
  }

  Timer _timer;
  Timer _timer1;

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (_timer) {
      getUserStatus();
    });
  }

  startSubscriptionStatusTimer() async {
    _timer1 = await Timer.periodic(Duration(minutes: 2), (_timer1) {
      print("object");
      userStatService.fetchSubscriptionStatus();
    });
  }

  void purchase() async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("purchasing");
      try {
        loading = true;
        print("secret key: ${Config.GOOGLE_SECRET_KEY}");
        if (Platform.isIOS) {
          successIos = await Purchases.purchaseProduct(additionalCredits[
                  additionalCredits.indexWhere(
                      (element) => element.credit == selectedCredit.value)]
              .productId);
          if (successIos.nonSubscriptionTransactions.toList().last.productId ==
              additionalCredits[additionalCredits.indexWhere(
                      (element) => element.credit == selectedCredit.value)]
                  .productId) {
            Purchases.setFinishTransactions(true);
            Purchases.syncPurchases();
            Get.snackbar("Success", "Purchased Successfully",
                backgroundColor: Colors.white);
            globals.addCreditStatus.value = false;
            loading = false;
            userStatService.fetchUserStatus();

            update();
          }
        } else {
          successAndroid = await Purchases.purchaseProduct(
              additionalCredits[additionalCredits.indexWhere(
                      (element) => element.credit == selectedCredit.value)]
                  .productId,
              type: PurchaseType.inapp);
          if (successAndroid.nonSubscriptionTransactions
                  .toList()
                  .last
                  .productId ==
              additionalCredits[additionalCredits.indexWhere(
                      (element) => element.credit == selectedCredit.value)]
                  .productId) {
            Purchases.syncPurchases();
            Purchases.canMakePayments();

            Get.snackbar("Success", "Purchased Successfully",
                backgroundColor: Colors.white);
            globals.addCreditStatus.value = false;

            loading = false;
            update();
          }
        }
      } on PlatformException catch (error) {
        loading = false;
        print("error:::" + error.details.toString());
        Get.snackbar("Purchase Failed.", "${error.message}",
            backgroundColor: Colors.white);
        update();
      }
      loading = false;
      update();
    } else {
      Fluttertoast.showToast(msg: "Device Not Connected to the Internet.");
    }
  }

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
    getAdditionalCredits();
    startSubscriptionStatusTimer();
    initPlatformState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
    _timer1.cancel();
  }
}
