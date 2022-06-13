import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:q4me/app/components/top_card.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/service/analytics_service.dart';

import '../controllers/reset_password_page_controller.dart';

class ResetPasswordPageView extends GetView<ResetPasswordPageController> {
  final ResetPasswordPageController _resetPasswordPageController =
      Get.put(ResetPasswordPageController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _resetPasswordPageController.initialize(context);
    WidgetsFlutterBinding.ensureInitialized();
    double marginHeight;
    var size = MediaQuery.of(context).size;
    print("height: " + size.height.toString());
    print("width: " + size.width.toString());

    if (size.height > 684 && size.height < 896) {
      marginHeight = (size.height - kToolbarHeight - 24) / 12;
    } else if (size.height < 684) {
      marginHeight = (size.height - kToolbarHeight - 24) / 13;
    } else if (size.height >= 896) {
      marginHeight = (size.height - kToolbarHeight - 24) / 9;
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: GetBuilder<ResetPasswordPageController>(
          builder: (builder) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      TopCard(
                        height: Get.height * 0.35,
                        topColor: const Color(0xff13253A),
                        bottomColor: const Color(0xff13253A),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: marginHeight,
                          ),
                          Center(
                            child: Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/logo_slogan.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: Platform.isIOS
                            ? size.height < 684
                                ? 10.0
                                : 42.0
                            : 12.0,
                        left: 12,
                        child: IconButton(
                            splashRadius: 1,
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xfa8BC34C),
                            )),
                      )
                    ],
                  ),
                  _resetPasswordPageController.confirmPassword == true
                      ? Container(
                          width: Get.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Reset Password",
                                style: TextStyle(
                                    color: Color(0xff13253a),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "We've sent you an email - \nPlease use the link to reset your\npassword",
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              SvgPicture.asset(
                                "assets/svgs/email.svg",
                                height: 89,
                                width: 67,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text("Check your email",
                                  style: TextStyle(
                                      color: Color(0xff8bc34c),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: Get.width,
                              child: const Center(
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Color(0xff13253A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
                                          style: TextStyle(
                                              height: 1.63,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.075),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Email",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _resetPasswordPageController
                                                          .emailController,
                                                  validator: (text) {
                                                    if (!text.isEmpty) {
                                                      if (!text.isEmail) {
                                                        return 'Please enter valid email.';
                                                      } else
                                                        return null;
                                                    } else {
                                                      return 'Email cannot be empty';
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        borderSide: BorderSide(
                                                          width: 0,
                                                          style:
                                                              BorderStyle.none,
                                                        ),
                                                      ),
                                                      fillColor:
                                                          Color(0xffffffff),
                                                      filled: true,
                                                      hintText: "eg@gmail.com",
                                                      hintStyle: TextStyle(
                                                          color: Color(
                                                              0xff949594)),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 20,
                                                              right: 20)),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xff222222),
                                                  ),
                                                ),
                                                SizedBox(height: 60),
                                                Obx(
                                                  () => Container(
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.11),
                                                            spreadRadius: 0.1,
                                                            blurRadius: 20,
                                                            offset:
                                                                Offset(0, 0),
                                                          )
                                                        ]),
                                                    child: MaterialButton(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      onPressed:
                                                          _resetPasswordPageController
                                                                      .state ==
                                                                  ViewState.Busy
                                                              ? null
                                                              : () {
                                                                  if (_formKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    locator<AnalyticsService>().logEvent(
                                                                        "reset_password",
                                                                        "reset password clicked");
                                                                    _resetPasswordPageController
                                                                        .resetPassword();
                                                                  } else
                                                                    return;
                                                                },
                                                      minWidth: Get.width,
                                                      disabledColor:
                                                          Color(0xff8BC34C),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(22.0),
                                                      ),
                                                      color: Color(0xff8BC34C),
                                                      child:
                                                          _resetPasswordPageController
                                                                      .state ==
                                                                  ViewState.Busy
                                                              ? Center(
                                                                  child: SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                                )
                                                              : Text(
                                                                  'Change Password',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
