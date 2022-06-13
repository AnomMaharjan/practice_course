import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/modules/OTP_page/bindings/o_t_p_page_binding.dart';
import 'package:q4me/app/modules/OTP_page/views/o_t_p_page_view.dart';
import 'package:q4me/app/modules/profile_page/controllers/profile_page_controller.dart';
import 'package:q4me/app/modules/profile_page/views/profile_page_view.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/address_finder.dart';
import 'package:q4me/service/analytics_service.dart';

import '../../../../api/new_apis.dart';
import '../../../../storage/shared_preferences_manager.dart';

class EditProfileController extends BaseController with Connection {
  final NewApi _newApi = NewApi();
  final ApiAuthProvider apiAuthProvider = ApiAuthProvider();
  AddressFinder addressFinder;
  List addressList = [];
  List addressFinderList = [].obs;
  final TextEditingController addressFinderController = TextEditingController();
  final TextEditingController currentPwController = TextEditingController();
  final TextEditingController newPwController = TextEditingController();
  final TextEditingController confirmNewController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController postCode = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  final ProfilePageController profilePageController = Get.find();

  RxBool hidePassword = false.obs;
  RxBool hideCurrentPassword = false.obs;
  RxBool hideConfirmPassword = false.obs;

  RxBool addressFinderPressed = false.obs;
  RxBool continueBtnColorStatus = false.obs;
  RxBool addressManuallyPressed = false.obs;
  RxBool addressManuallyPressedErrorPopUp = false.obs;

  RxBool lengthValidator = false.obs;
  RxBool numberValidator = false.obs;
  RxBool capitalLetterValidator = false.obs;
  RxBool specialLetterValidator = false.obs;

  RxBool addressManually = false.obs;
  RxBool newPasswordPressed = false.obs;

  RxBool addressFinderDropDownList = false.obs;
  String phoneNumber = Get.arguments['phoneNo'];
  var pwResponse;

  var currentPasswordCorrect = false.obs;
  var newPasswordCorrect = false.obs;
  var confirmPasswordCorrect = false.obs;
  String phoneNumberTrimmed;

  final AnalyticsService analyticsService = locator<AnalyticsService>();

  String countryCode;
  final SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();

  void hideNewPwEyeBtn() {
    hidePassword.value = !hidePassword.value;
  }

  void hideCurntPwEyeBtn() {
    hideCurrentPassword.value = !hideCurrentPassword.value;
  }

  void hideConfirmEyeBtn() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  bool changeBtnColorForPassword() {
    if (newPwController.text.isNotEmpty &&
        currentPwController.text.isNotEmpty &&
        confirmNewController.text.isNotEmpty)
      return continueBtnColorStatus.value = true;
    else
      return continueBtnColorStatus.value = false;
  }

  bool changeBtnColorForAddress() {
    if (addressFinderController.text.isNotEmpty)
      return continueBtnColorStatus.value = true;
    else if (addressLine1Controller.text.isNotEmpty ||
        addressLine2Controller.text.isNotEmpty ||
        postCode.text.isNotEmpty)
      return continueBtnColorStatus.value = true;
    else
      return continueBtnColorStatus.value = false;
  }

  bool changeBtnColorForPhone() {
    if (phoneNumberController.text.isNotEmpty)
      return continueBtnColorStatus.value = true;
    else
      return continueBtnColorStatus.value = false;
  }

  void getAddress({String postCode}) async {
    setState(ViewState.Busy);
    addressFinder = await _newApi.fetchAddressFinder(postCode: postCode);
    if (addressFinder != null)
      addressFinderList.assignAll(addressFinder.results);
    print(addressFinderList[0].id);
    setState(ViewState.Retrieved);
  }

  void changePw() async {
    Map body = {
      "current_password": currentPwController.text,
      "password": newPwController.text,
      "confirm_password": confirmNewController.text
    };
    try {
      setState(ViewState.Busy);

      await _newApi.getChangePw(body: body).then(
        (value) {
          setState(ViewState.Retrieved);
          print("asdf" + value);
          addressManuallyPressedErrorPopUp.value = true;
          errorText.value = value;
          if (value == 'Password reseted successfully') {
            Fluttertoast.showToast(msg: "Password reseted successfully");
            currentPwController.clearComposing();
            currentPwController.clear();

            newPwController.clearComposing();
            newPwController.clear();

            confirmNewController.clearComposing();
            confirmNewController.clear();
            lengthValidator.value = false;
            capitalLetterValidator.value = false;
            numberValidator.value = false;
            specialLetterValidator.value = false;
            Get.back();
            profilePageController.getProfileInfo();
            Get.to(() => ProfilePageView());
            setState(ViewState.Retrieved);
          } else if (currentPwController.text.isEmpty &&
              newPwController.text.isEmpty &&
              confirmNewController.text.isEmpty) {
            addressManuallyPressedErrorPopUp.value = true;
            errorText.value = '''Fields Can't be empty''';
            currentPasswordCorrect.value = true;
            newPasswordCorrect.value = true;
            confirmPasswordCorrect.value = true;
          } else if (value == "Current password did not match ") {
            print('object');
            currentPasswordCorrect.value = true;
            newPasswordCorrect.value = true;
            confirmPasswordCorrect.value = true;
          } else if (value != "Current password did not match " &&
              currentPwController.text.isNotEmpty) {
            currentPasswordCorrect.value = false;
          } else if (value == "Password must contain atleast 1 digit " ||
              value == "Password must contain atleast 1 capital alphabet " ||
              value == "Password must contain atleast 1 special Character ") {
            newPasswordCorrect.value = true;
          } else if (lengthValidator.value &&
              capitalLetterValidator.value &&
              numberValidator.value &&
              specialLetterValidator.value) {
            newPasswordCorrect.value = false;
          } else if (newPwController.text != confirmNewController.text) {
            confirmPasswordCorrect.value = true;
          }
        },
      );
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: "$e", gravity: ToastGravity.TOP);
    }
    setState(ViewState.Retrieved);
  }

  var address1;
  var address2;
  var postalCode;

  void postAddress({String postalCode}) async {
    print('${postalCode = addressFinderController.text}');
    print(address1);
    print(postalCode);

    Map body = {
      "address_1": '',
      "postal_code": postalCode,
      "address_2": "",
    };
    if (addressFinderController.text.isNotEmpty) {
      await _newApi.postAddresss(body: body);
      setState(ViewState.Busy);
      await _newApi.clearCache(endpoint: '/api/user/information/retrieve/');
      Fluttertoast.showToast(
          msg: "Successfully updated", gravity: ToastGravity.TOP);
      Get.back();
      await profilePageController.getProfileInfo();
      Get.to(() => ProfilePageView());
      addressFinderController.clear();
      addressFinderController.clearComposing();
      continueBtnColorStatus.value = false;
      setState(ViewState.Retrieved);
    } else
      Fluttertoast.showToast(
          msg: "Field cannot be empty", gravity: ToastGravity.TOP);
  }

  void postAdressManualy() async {
    Map body = {
      "address_1": addressLine1Controller.text,
      "address_2": addressLine2Controller.text,
      "postal_code": postCode.text,
    };
    if (addressLine1Controller.text.isNotEmpty ||
        addressLine2Controller.text.isNotEmpty ||
        postCode.text.isNotEmpty) {
      setState(ViewState.Busy);
      await _newApi.postAddresss(body: body);
      await _newApi.clearCache(endpoint: '/api/user/information/retrieve/');
      Fluttertoast.showToast(
          msg: "Successfully updated", gravity: ToastGravity.TOP);
      addressLine1Controller.clear();
      addressLine2Controller.clear();
      postCode.clear();
      continueBtnColorStatus.value = false;
      Get.back();
      await profilePageController.getProfileInfo();
      Get.to(() => ProfilePageView());
      setState(ViewState.Retrieved);
    } else
      Fluttertoast.showToast(
          msg: "Field cannot be empty", gravity: ToastGravity.TOP);
  }

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
          arguments: {"from": "profilePage"},
          binding: OTPPageBinding());
      setState(ViewState.Retrieved);
      update();
    }
    setState(ViewState.Retrieved);
    update();
  }

  RxString errorText = ''.obs;
  RxBool errorBox = false.obs;

  void forPwCheck() {
    // changePw();

    if (currentPwController.text.isEmpty &&
        newPwController.text.isEmpty &&
        confirmNewController.text.isEmpty) {
      addressManuallyPressedErrorPopUp.value = true;
      errorText.value = '''Fields Can't be empty''';
      currentPasswordCorrect.value = true;
      newPasswordCorrect.value = true;
      confirmPasswordCorrect.value = true;
    } else if (currentPwController.text.isNotEmpty &&
        errorText.value == "This field may not be blank") {
      errorText.value = '''confirm new password can not be empty''';
      currentPasswordCorrect.value = false;
    } else if (newPwController.text != confirmNewController.text) {
      addressManuallyPressedErrorPopUp.value = true;
      errorText.value = '''Password do not match''';
    } else {
      addressManuallyPressedErrorPopUp.value = false;
      setState(ViewState.Busy);
      setState(ViewState.Retrieved);
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
    addressManuallyPressedErrorPopUp.value = false;
    countryCode = phoneNumber.substring(0, 4);
    phoneNumberController.text = phoneNumber.substring(4);
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
    addressManuallyPressedErrorPopUp.value = false;

    addressFinderController.clear();
    addressFinderController.clear();
    currentPwController.clear();
    newPwController.clear();
    confirmNewController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    postCode.clear();
    phoneNumberController.clear();
    passwordController.clear();
    reEnterPasswordController.clear();
  }
}
