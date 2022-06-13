import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/modules/profile_page/controllers/profile_page_controller.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';

class OTPPageController extends BaseController with Connection {
  final ApiAuthProvider apiAuthProvider = ApiAuthProvider();
  final ProfilePageController profilePageController =
      Get.put(ProfilePageController());
  final SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  bool isLoading = false;
  String otpCode = "";
  bool timerRunning = false;
  String code = "";

  Timer _timer;
  int start = 59;
  String from;

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    super.onInit();
    from = Get.arguments["from"];

    startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }

  void checkAudioRecorded() {
    if (sharedPreferencesManager.getBool("isSubscribed") == false) {
      Get.offAllNamed(Routes.TRIAL_PAGE);
      isLoading = false;
      update();
    } else {
      Get.offAllNamed(Routes.HOMEPAGE);
      isLoading = false;
      update();
    }
  }

  void mapPhoneNumber({String otpCode}) async {
    isLoading = true;
    update();
    var phoneNumberResponse = await apiAuthProvider.updatePhoneNumber(
        otpCode: otpCode,
        serviceId: sharedPreferencesManager.getString("serviceId"));
    if (phoneNumberResponse == true) {
      otpCode = "";
      await locator<SharedPreferencesManager>().putBool('callGoing', false);
      await sharedPreferencesManager.putBool(
          SharedPreferencesManager.keyIsLogin, true);

      await sharedPreferencesManager.putBool("phoneNumberAdded", true);
      if (from == "profilePage") {
        Get.back();
        await profilePageController.getProfileInfo();
      } else
        checkAudioRecorded();
      Fluttertoast.showToast(
          msg: "Mobile number verified successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: GLOBAL_GREEN_COLOR,
          textColor: Colors.white,
          fontSize: 16.0);
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  }

  void startTimer() {
    timerRunning = true;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timerRunning = false;
          timer.cancel();
          start = 59;
          update();
        } else {
          start--;
          update();
        }
      },
    );
  }

  void checkOTPStatus({String phoneNumber}) async {
    setState(ViewState.Busy);
    var otpStatus =
        await apiAuthProvider.getOTPStatus(phoneNumber: phoneNumber);
    print("otp response: $otpStatus");
    if (otpStatus != null) {
      sharedPreferencesManager.putString("serviceId", otpStatus.serviceSid);
      print("sid: ${sharedPreferencesManager.getString("serviceId")}");
      update();
      startTimer();
      setState(ViewState.Retrieved);
      update();
    }
    setState(ViewState.Retrieved);
    update();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }
}
