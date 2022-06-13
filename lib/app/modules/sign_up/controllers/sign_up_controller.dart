import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/service/analytics_service.dart';

class SignUpController extends BaseController with Connection {
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  var hidePassword = true.obs;
  bool verifyEmail = false;
  var hideReEnterPassword = true.obs;
  dynamic response;
  RxBool lengthValidator = false.obs;
  RxBool numberValidator = false.obs;
  RxBool capitalLetterValidator = false.obs;
  RxBool specialLetterValidator = false.obs;
  RxBool condition5 = false.obs;
  RxBool passwordsDonotMatch = false.obs;
  RxBool inputFieldFocused = false.obs;
  RxBool passwordEmpty = false.obs;
  RxBool reEnterPasswordEmpty = false.obs;
  RxBool emailEmpty = false.obs;
  BuildContext contexts;

  bool proceedToLogin =
      false; //to show proceed to login page. If false it shows sign up form else shows proceed to login page.
  var loading = false.obs; //Indicates the viewstate of sign up view.

  bool termsAndConditions = false; //
  bool privacyPolicy = false;

  final AnalyticsService analyticsService = locator<AnalyticsService>();

  void showHidePassword() {
    hidePassword.value = !hidePassword.value;
    update();
  }

  void showHideReEnterPassword() {
    hideReEnterPassword.value = !hideReEnterPassword.value;
    update();
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

  void mapInput() {
    Map map = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "password2": reEnterPasswordController.text.trim(),
    };
    register(map);
  }

  Future<dynamic> register(Map map) async {
    loading.value = true;
    response = await _apiAuthProvider.register(map);
    print('response ${response}');
    if (response == true) {
      print('success');
      verifyEmail = true;
      Future.delayed(Duration(seconds: 5), () {
        proceedToLogin = true;
        update();
      });
      loading.value = false;
      update();
    } else if (response == null)
      Get.snackbar("Registration Failed",
          "Could not register your account. Please try again.");
    loading.value = false;
    update();
  }

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }
}
