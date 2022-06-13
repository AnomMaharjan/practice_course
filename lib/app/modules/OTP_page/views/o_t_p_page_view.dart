import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';
import '../controllers/o_t_p_page_controller.dart';

class OTPPageView extends GetView<OTPPageController> {
  final String phoneNumber;

  OTPPageView({this.phoneNumber});

  final OTPPageController _otpPageController = Get.put(OTPPageController());
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _otpPageController.initialize(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: GetBuilder<OTPPageController>(
              builder: (builder) => Stack(
                    children: [
                      Container(
                        width: Get.width,
                        height: Get.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Platform.isIOS
                                  ? Get.height * 0.1
                                  : Get.height * 0.06,
                            ),
                            Text(
                              "Verification Code",
                              style: TextStyle(
                                  fontSize: 26,
                                  color: GLOBAL_THEME_COLOR,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text:
                                      'Please enter the verification code sent\n',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.black,
                                      fontSize: 16),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' to',
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: " $phoneNumber",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0xff222222),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: Get.height * 0.05,
                            ),
                            SizedBox(
                              width: Get.width * 0.65,
                              child: PinCodeTextField(
                                textStyle: TextStyle(
                                    color: GLOBAL_THEME_COLOR, fontSize: 26),
                                pinTheme: PinTheme.defaults(
                                    fieldWidth: 30,
                                    selectedColor: Color(0xff222222),
                                    activeColor: Color(0xff222222),
                                    inactiveColor: Color(0xff222222)),
                                appContext: context,
                                length: 6,
                                onChanged: (value) {
                                  _otpPageController.otpCode = value;
                                  _otpPageController.update();
                                },
                                cursorColor: GLOBAL_THEME_COLOR,
                                animationType: AnimationType.none,
                                autoDismissKeyboard: true,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.3,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 45.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      )
                                    ]),
                                child: MaterialButton(
                                  height: 44,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60)),
                                  minWidth: Get.width,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  elevation: 2,
                                  disabledColor: Color(0xffD2CFCF),
                                  onPressed: _otpPageController
                                              .otpCode.length !=
                                          6
                                      ? null
                                      : () async {
                                          await locator<
                                                  SharedPreferencesManager>()
                                              .putString(
                                                  "phonenumber", phoneNumber);
                                          _otpPageController.mapPhoneNumber(
                                            otpCode: _otpPageController.otpCode,
                                          );
                                          print("phoneNumber: $phoneNumber");
                                        },
                                  color: GLOBAL_GREEN_COLOR,
                                  child: _otpPageController.isLoading
                                      ? Center(
                                          child: Container(
                                              height: 28,
                                              width: 28,
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : Text(
                                          "Verify & Proceed",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Or",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Obx(() => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 45.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(25.0),
                                        ),
                                        boxShadow: [
                                          _otpPageController.timerRunning
                                              ? BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 4),
                                                )
                                              : BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 4),
                                                )
                                        ]),
                                    child: MaterialButton(
                                      disabledTextColor: Color(0xffD2CFCF),
                                      height: 44,
                                      textColor: GLOBAL_GREEN_COLOR,
                                      minWidth: Get.width,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      onPressed: _otpPageController.timerRunning
                                          ? null
                                          : () {
                                              _otpPageController.checkOTPStatus(
                                                  phoneNumber: phoneNumber);
                                            },
                                      disabledColor: Colors.white,
                                      color: Colors.white,
                                      child: _otpPageController.state ==
                                              ViewState.Busy
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Text(
                                              "Resend OTP",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                    ),
                                  ),
                                )),
                            SizedBox(height: 15),
                            _otpPageController.timerRunning
                                ? RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: 'You can resend OTP again in\n',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                " 00:${_otpPageController.start < 10 ? '0' : ''}${_otpPageController.start}",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: GLOBAL_THEME_COLOR,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Platform.isIOS
                                ? size.height < 668
                                    ? 0
                                    : Get.height * 0.04
                                : 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(Icons.arrow_back_ios,
                                color: GLOBAL_GREEN_COLOR),
                            splashRadius: 1,
                          ),
                        ),
                      ),
                      _otpPageController.state == ViewState.Busy
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox()
                    ],
                  )),
        ),
      ),
    );
  }
}
