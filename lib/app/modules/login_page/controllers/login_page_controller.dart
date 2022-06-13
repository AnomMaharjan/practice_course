import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/modules/OTP_page/bindings/o_t_p_page_binding.dart';
import 'package:q4me/app/modules/OTP_page/views/o_t_p_page_view.dart';
import 'package:q4me/app/modules/trial_page/bindings/trial_page_binding.dart';
import 'package:q4me/app/modules/trial_page/views/trial_page_view.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/login_model.dart';
import 'package:q4me/model/phone_number_response.dart';
import 'package:q4me/model/sign_in_with_apple_login_model.dart';
import 'package:q4me/model/sign_in_with_google.dart';
import 'package:q4me/model/user_stats_model.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';
import 'package:q4me/widgets/button.dart';
import 'package:q4me/widgets/country_code_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPageController extends BaseController with Connection {
  RxBool hidePassword = true.obs;
  //variables for google signup
  var googleSignin = GoogleSignIn();
  GoogleSignInAccount googleSignInAccount;
  GoogleSignInAuthentication googleSignInAuthentication;
  String accessToken;
  String idToken;
  GoogleLoginResponse googleLoginResponse;
  final ApiAuthProvider apiAuthProvider = ApiAuthProvider();
  final SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginResponse loginResponse;
  RxBool isLoading = false.obs;
  final TextEditingController phoneNumberController = TextEditingController();
  UserStats userStats;
  PhoneNumberResponse phoneNumberResponse;
  String countryCode;

  //variables for apple signup
  RxBool isLoadingApple = false.obs;
  AppleLoginResponse appleLoginResponse;
  String authorizationCode;
  String identityToken;
  PurchaserInfo purchaserInfo;
  BuildContext contexts;

  final AnalyticsService analyticsService = locator<AnalyticsService>();

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    super.onInit();
    initPlatformState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<LoginPageController>();
  }

  //initializing revenuecat platform for in-app purchases
  Future<void> initPlatformState() async {
    if (Platform.isIOS) {
      await Purchases.setup(APPLE_SECRET_KEY,
          observerMode: false,
          appUserId: locator<SharedPreferencesManager>().getString("username"));
    } else {
      await Purchases.setup(GOOGLE_SECRET_KEY,
          observerMode: false,
          appUserId: locator<SharedPreferencesManager>().getString("username"));
    }
    await Purchases.setDebugLogsEnabled(true);
    purchaserInfo = await Purchases.getPurchaserInfo();

    if (Platform.isIOS) {
      if (purchaserInfo.entitlements.all["one credit per month"].isActive) {
        sharedPreferencesManager.putBool("isSubscribed", true);
      } else {
        sharedPreferencesManager.putBool("isSubscribed", false);
      }
      print('purchaserinfo: $purchaserInfo');
      print('purchaserinfo: ${purchaserInfo.entitlements.all}');
    } else {
      if (purchaserInfo.entitlements.all["one credit per month"].isActive) {
        sharedPreferencesManager.putBool("isSubscribed", true);
      } else {
        sharedPreferencesManager.putBool("isSubscribed", false);
      }
      print('purchaserinfo: $purchaserInfo');
      print('purchaserinfo: ${purchaserInfo.entitlements.all}');
    }
  }

  //function to hide/show password
  void showHidePassword() {
    hidePassword.value = !hidePassword.value;
    update();
  }

  //login with google
  void loginGoogle(BuildContext context) async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.getToken().then((value) {
      locator<SharedPreferencesManager>()
          .putString(SharedPreferencesManager.keyFCMToken, value);
    });
    if (sharedPreferencesManager.isKeyExists("isGoogleLogin") == true) {
      googleSignin.signOut();
      googleSignInAccount = await googleSignin.signIn();
      print(googleSignInAccount.displayName);
      if (googleSignInAccount != null) {
        googleSignInAuthentication = await googleSignInAccount.authentication;
        authenticate(context);
      }
    } else {
      googleSignInAccount = await googleSignin.signIn();
      if (googleSignInAccount != null) {
        googleSignInAuthentication = await googleSignInAccount.authentication;
        authenticate(context);
      }
    }
  }

  //maps google input for logging in with google
  void mapGoogleLogin(BuildContext context) async {
    Map googleMap = {
      "access_token": accessToken,
      "id_token": idToken,
      "fcm_token": await sharedPreferencesManager.getString('FCMToken')
    };
    googleLoginResponse = await apiAuthProvider.googleLogin(googleMap);
    if (googleLoginResponse != null) {
      await sharedPreferencesManager.putBool(
          "autoretry", googleLoginResponse.autoRetry);
      await sharedPreferencesManager.putString(
          "accessToken", googleLoginResponse.token);
      await sharedPreferencesManager.putBool(
          "isSocial", googleLoginResponse.isSocial);
      userStats = await apiAuthProvider.fetchUserStat();
      await sharedPreferencesManager.putBool(
          "isSubscribed", userStats.subscriptionStatus);
      await sharedPreferencesManager.putInt(
          "remainingCredit", userStats.remainingCredits);
      await sharedPreferencesManager.putDouble(
          "hoursSaved", userStats.totalHoursSaved ?? 0.0);
      await sharedPreferencesManager.putBool("isCreditZero", false);
      await sharedPreferencesManager.putInt(
          SharedPreferencesManager.keyID, googleLoginResponse.id);
      await sharedPreferencesManager.putString(
          SharedPreferencesManager.keyUsername, googleLoginResponse.username);
      await sharedPreferencesManager.putBool("isGoogleLogin", true);
      // await sharedPreferencesManager.putBool(
      //     SharedPreferencesManager.keyIsLogin, true);
      isLoading.value = false;
      update();
      if (googleLoginResponse.numberStatus == true) {
        checkAudioRecorded();
        await sharedPreferencesManager.putBool(
            SharedPreferencesManager.keyIsLogin, true);
        await locator<SharedPreferencesManager>().putBool('callGoing', false);
        await sharedPreferencesManager.putString(
            "phonenumber", googleLoginResponse.phoneNumber);
        await sharedPreferencesManager.putBool("phoneNumberAdded", true);
        await sharedPreferencesManager.putBool("isCreditZero", false);
      } else
        showPhoneNumberDialog();
      // showPhoneNumberPopup(context);
    } else {
      isLoading.value = false;
      Fluttertoast.showToast(
          msg: "User is already registered with this e-mail address.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.blue[300],
          textColor: Colors.white,
          fontSize: 16.0);
      logout();
    }
    update();
  }

  //authenticates the google login process
  void authenticate(BuildContext context) async {
    isLoading.value = true;
    update();
    if (googleSignInAuthentication != null) {
      print("google access token ${googleSignInAuthentication.accessToken}");
      print("google id token ${googleSignInAuthentication.idToken}");
      print("name: ${googleSignInAuthentication}");
      accessToken = googleSignInAuthentication.accessToken;
      idToken = googleSignInAuthentication.idToken;
      mapGoogleLogin(context);
    } else {
      isLoading.value = false;
      Fluttertoast.showToast(
          msg: "Unable to sign in!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.blue[300],
          textColor: Colors.white,
          fontSize: 16.0);
      update();
    }
  }

  //logsout from google account
  void logout() async {
    googleSignInAccount = await googleSignin.signOut();
  }

  //checks audio recorded status to navigate to trial page or init page.
  void checkAudioRecorded() {
    if (sharedPreferencesManager.getBool("isSubscribed") == false) {
      Get.offAll(() => TrialPageView(), binding: TrialPageBinding());
      isLoading.value = false;
      update();
    } else {
      Get.offAllNamed(Routes.HOMEPAGE);
      isLoading.value = false;
      update();
    }
  }

  showPhoneNumberDialog() {
    showDialog(
      context: Get.overlayContext,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xfff2f2f2),
          child: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xfff2f2f2),
                  borderRadius: BorderRadius.circular(20)),
              height: 285,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: EdgeInsets.only(right: 20, top: 20),
                        child: GestureDetector(
                            onTap: () => Get.back(),
                            child: SvgPicture.asset(
                              "assets/svgs/cross1.svg",
                              height: 18,
                              width: 16,
                            ))),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Enter Your Mobile Number",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: GLOBAL_THEME_COLOR),
                  ),
                  SizedBox(height: 18),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            //countrycodepicker
                            child: CountryCodePicker(
                              padding: EdgeInsets.zero,
                              textStyle: TextStyle(
                                  fontSize: 13, color: Color(0xff222222)),
                              showFlag: true,
                              flagWidth:
                                  MediaQuery.of(context).size.height > 812
                                      ? 55
                                      : 50,
                              deviceSize: MediaQuery.of(context).size.height,
                              flagDecoration:
                                  BoxDecoration(shape: BoxShape.circle),
                              initialSelection: 'GB',
                              favorite: ["+44", 'GB'],
                              showDropDownButton: true,
                              onInit: (value) {
                                countryCode = value.toString();
                              },
                              onChanged: (value) {
                                countryCode = value.toString();
                                print("value: $countryCode");
                              },
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(left: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextFormField(
                              autofocus: true,
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(fontSize: 13),
                                  border: InputBorder.none,
                                  counterText: "",
                                  filled: true,
                                  contentPadding:
                                      EdgeInsets.only(left: 14.0, bottom: 10),
                                  hintText: 'Enter Mobile Number',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              validator: (text) {
                                if (text.isEmpty) {
                                  return 'Phone Number cannot be empty';
                                } else
                                  return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Obx(
                      () => Button(
                        onClick: state == ViewState.Busy
                            ? null
                            : () {
                                if (_formKey.currentState.validate()) {
                                  checkOTPStatus(
                                      phoneNumber: countryCode +
                                          phoneNumberController.text.trim(),
                                      context: context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Enter valid mobile number",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.TOP,
                                      backgroundColor: Colors.blue[300],
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                        child: state == ViewState.Busy
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                "Submit",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xfff2f2f2),
                                ),
                              ),
                        buttonColor: Color(0xff8bc34c),
                        buttonShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        height: 44,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String errorText;
  RxBool errorEmail = false.obs;
  RxBool errorPassword = false.obs;

  //login user via email
  void loginUser(Map map, BuildContext context) async {
    setState(ViewState.Busy);
    await apiAuthProvider.loginUser(map).then((value) {
      if (value.runtimeType == String) {
        String error = value
            .toString()
            .substring((value.length - 3).clamp(0, value.length));
        if (error == "400") {
          print(value.toString().substring(0, value.length - 3));
          errorText = value.toString().substring(0, value.length - 3);
          errorEmail.value = true;
          print(errorText);
          setState(ViewState.Retrieved);
        } else if (error == "404") {
          print(value.toString().substring(0, value.length - 3));
          errorPassword.value = true;
          errorEmail.value = false;
          errorText = value.toString().substring(0, value.length - 3);
          print(errorText);
          setState(ViewState.Retrieved);
        } else if (error == "502") {
          print(value.toString().substring(0, value.length - 3));
          errorPassword.value = false;
          errorEmail.value = false;
          errorText = value.toString().substring(0, value.length - 3);
          print(errorText);
          setState(ViewState.Retrieved);
        }
        print("asdfsd ${value.toString()}");
        print(error);
      } else {
        setState(ViewState.Busy);
        errorEmail.value = false;
        errorPassword.value = false;
        loginResponse = value;
        print('success');
      }
    });
    await sharedPreferencesManager.putString(
        SharedPreferencesManager.keyAccessToken, loginResponse.token);
    await sharedPreferencesManager.putBool(
        "autoretry", loginResponse.autoRetry);
    userStats = await apiAuthProvider.fetchUserStat();
    if (userStats.remainingCredits == null) {
      await sharedPreferencesManager.putInt("remainingCredit", 0);
    } else {
      await sharedPreferencesManager.putInt(
          "remainingCredit", userStats.remainingCredits);
    }
    await sharedPreferencesManager.putString(
        SharedPreferencesManager.keyUsername, loginResponse.username);
    await sharedPreferencesManager.putBool("autoretry", userStats.autoRetry);
    await sharedPreferencesManager.putDouble(
        "hoursSaved", userStats.totalHoursSaved ?? 0.0);
    await sharedPreferencesManager.putBool(
        "isSubscribed", userStats.subscriptionStatus);
    await sharedPreferencesManager.putString(
        SharedPreferencesManager.keyPhoneNumber, loginResponse.phoneNumber);
    await sharedPreferencesManager.putBool("isCreditZero", false);
    await locator<SharedPreferencesManager>().putBool('callGoing', false);
    userStats = await apiAuthProvider.fetchUserStat();
    if (userStats.remainingCredits == null) {
      await sharedPreferencesManager.putInt("remainingCredit", 0);
    } else {
      await sharedPreferencesManager.putInt(
          "remainingCredit", userStats.remainingCredits.toInt());
    }
    await sharedPreferencesManager.putDouble(
        "hoursSaved", userStats.totalHoursSaved ?? 0.0);
    await sharedPreferencesManager.putBool(
        "isSubscribed", userStats.subscriptionStatus);
    if (loginResponse.phoneNumber == "") {
      // removed from here
      showPhoneNumberDialog();
      setState(ViewState.Retrieved);
      update();
    } else {
      await sharedPreferencesManager.putBool("phoneNumberAdded", true);
      await sharedPreferencesManager.putBool(
          SharedPreferencesManager.keyIsLogin, true);
      await sharedPreferencesManager.putString(
          SharedPreferencesManager.keyPhoneNumber, loginResponse.phoneNumber);
      await sharedPreferencesManager.putBool("isCreditZero", false);
      await locator<SharedPreferencesManager>().putBool('callGoing', false);
      userStats = await apiAuthProvider.fetchUserStat();
      if (userStats.remainingCredits == null) {
        await sharedPreferencesManager.putInt("remainingCredit", 0);
      } else {
        await sharedPreferencesManager.putInt(
            "remainingCredit", userStats.remainingCredits.toInt());
      }
      await sharedPreferencesManager.putDouble(
          "hoursSaved", userStats.totalHoursSaved ?? 0.0);
      await sharedPreferencesManager.putBool(
          "isSubscribed", userStats.subscriptionStatus);
      checkAudioRecorded();
      setState(ViewState.Retrieved);
      update();
    }
  }

  //maps user input for logging in
  Future<void> mapInputsLogin(BuildContext context) async {
    setState(ViewState.Busy);
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.getToken().then((value) {
      locator<SharedPreferencesManager>()
          .putString(SharedPreferencesManager.keyFCMToken, value);
    });
    Map map = {
      "username": usernameController.text.trim(),
      "password": passwordController.text.trim(),
      "token": await sharedPreferencesManager.getString('FCMToken')
    };
    loginUser(map, context);
    update();
  }

  //maps apple input for logging in
  void mapAppleLogin(BuildContext context) async {
    isLoadingApple.value = true;
    Map appleMap = {
      "access_token": authorizationCode,
      "id_token": identityToken,
      "fcm_token": await sharedPreferencesManager.getString('FCMToken')
    };
    appleLoginResponse = await apiAuthProvider.appleLogin(appleMap);
    if (appleLoginResponse != null) {
      await sharedPreferencesManager.putBool(
          "isSocial", appleLoginResponse.isSocial);
      await sharedPreferencesManager.putString(
          "accessToken", appleLoginResponse.token);
      await sharedPreferencesManager.putBool(
          "autoretry", appleLoginResponse.autoRetry);
      userStats = await apiAuthProvider.fetchUserStat();
      await sharedPreferencesManager.putBool(
          "isSubscribed", userStats.subscriptionStatus);
      await sharedPreferencesManager.putInt(
          "remainingCredit", userStats.remainingCredits.toInt());
      await sharedPreferencesManager.putDouble(
          "hoursSaved", userStats.totalHoursSaved ?? 0.0);
      await sharedPreferencesManager.putBool("isCreditZero", false);
      await sharedPreferencesManager.putInt(
          SharedPreferencesManager.keyID, appleLoginResponse.id);
      await sharedPreferencesManager.putString(
          SharedPreferencesManager.keyUsername, appleLoginResponse.username);
      // await sharedPreferencesManager.putBool(
      //     SharedPreferencesManager.keyIsLogin, true);
      isLoadingApple.value = false;
      update();
      if (appleLoginResponse.numberStatus == true) {
        checkAudioRecorded();
        await sharedPreferencesManager.putBool(
            SharedPreferencesManager.keyIsLogin, true);
        await locator<SharedPreferencesManager>().putBool('callGoing', false);
        await sharedPreferencesManager.putString(
            "phonenumber", appleLoginResponse.phoneNumber);
        await sharedPreferencesManager.putBool("phoneNumberAdded", true);
        await sharedPreferencesManager.putBool("isCreditZero", false);
      } else
        showPhoneNumberDialog();
      // showPhoneNumberPopup(context);
    } else {
      isLoadingApple.value = false;
      update();
    }
    update();
  }

  //checks if the number is registered or not via OTP
  void checkOTPStatus({String phoneNumber, BuildContext context}) async {
    setState(ViewState.Busy);
    var otpStatus =
        await apiAuthProvider.getOTPStatus(phoneNumber: phoneNumber);
    print("otp response: $otpStatus");
    if (otpStatus != null) {
      sharedPreferencesManager.putString("serviceId", otpStatus.serviceSid);
      print("sid: ${sharedPreferencesManager.getString("serviceId")}");
      update();
      Navigator.of(context).pop();
      Get.to(
          () => OTPPageView(
              phoneNumber: countryCode + phoneNumberController.text),
          arguments: {"from": "loginPage"},
          binding: OTPPageBinding());
      setState(ViewState.Retrieved);
      update();
    }
    setState(ViewState.Retrieved);
    update();
  }

  //verifies user with apple ID
  void signInWithApple(BuildContext context) async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.getToken().then((value) {
      locator<SharedPreferencesManager>()
          .putString(SharedPreferencesManager.keyFCMToken, value);
    });
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (credential != null) {
      authorizationCode = credential.authorizationCode;
      identityToken = credential.identityToken;
      print('apple authorization code: ${authorizationCode}');
      print('apple identity code: ${identityToken}');
      mapAppleLogin(context);
      print(credential);
      update();
    } else {
      Fluttertoast.showToast(
          msg: "Unable to sign in.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.blue[300],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
