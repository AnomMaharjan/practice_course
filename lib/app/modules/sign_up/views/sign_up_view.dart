import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q4me/app/components/top_card.dart';
import 'package:q4me/app/modules/login_page/bindings/login_page_binding.dart';
import 'package:q4me/app/modules/login_page/controllers/login_page_controller.dart';
import 'package:q4me/app/modules/login_page/views/login_page_view.dart';
import 'package:q4me/widgets/button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  final _formKey = GlobalKey<FormState>();
  final SignUpController _signUpController = Get.put(SignUpController());
  final LoginPageController _loginPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    double marginHeight;
    var size = MediaQuery.of(context).size;
    print("height: " + size.height.toString());
    print("width: " + size.width.toString());
    final FocusScopeNode currentScope = FocusScope.of(context);

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
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            _signUpController.inputFieldFocused.value = false;
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: GetBuilder<SignUpController>(builder: (builder) {
          return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
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
                    ]),
                    _signUpController.verifyEmail == true
                        ? Container(
                            width: Get.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Email Confirmation",
                                  style: TextStyle(
                                      color: Color(0xff13253a),
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Your account has been created",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "We've sent you an email - we \nneed you to verify your email \naddress before registration \nis complete.",
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                SvgPicture.asset(
                                  "assets/svgs/email.svg",
                                  height: 89,
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
                                _signUpController.proceedToLogin
                                    ? InkWell(
                                        onTap: () => Get.offAll(
                                            () => LoginPageView(),
                                            binding: LoginPageBinding()),
                                        child: Text("Proceed to login",
                                            style: TextStyle(
                                              color: Color(0xff8bc34c),
                                              fontSize: 16,
                                            )),
                                      )
                                    : SizedBox()
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
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Color(0xff13253A),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Obx(
                                () => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Email',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              emailInputField(
                                                  "eg: email@email.com",
                                                  14,
                                                  Color(0xff949594)),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Password',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              passwordField("eg: xxxxxx", 14,
                                                  Color(0xff949594)),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              _signUpController
                                                      .inputFieldFocused.value
                                                  ? CustomBox(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "Password Requirements",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          const SizedBox(
                                                              height: 9),
                                                          passwordValidationWidget(
                                                            content:
                                                                "At least 8 characters",
                                                            status: _signUpController
                                                                .lengthValidator
                                                                .value,
                                                          ),
                                                          passwordValidationWidget(
                                                            content:
                                                                "At least 1 number",
                                                            status: _signUpController
                                                                .numberValidator
                                                                .value,
                                                          ),
                                                          passwordValidationWidget(
                                                            content:
                                                                "At least 1 capital letter",
                                                            status: _signUpController
                                                                .capitalLetterValidator
                                                                .value,
                                                          ),
                                                          passwordValidationWidget(
                                                            content:
                                                                "At least 1 special character",
                                                            status: _signUpController
                                                                .specialLetterValidator
                                                                .value,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Re-Enter Password',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 6),
                                              reEnterPasswordField("eg: xxxxxx",
                                                  14, Color(0xff949594)),
                                              const SizedBox(height: 32),
                                              //from here
                                             (_signUpController.emailController.text.isEmpty ||
                                                          _signUpController
                                                              .reEnterPasswordController
                                                              .text
                                                              .isEmpty ||
                                                          _signUpController
                                                              .passwordController
                                                              .text
                                                              .isEmpty) &&
                                                      (_signUpController.emailEmpty.value ||
                                                          _signUpController
                                                              .reEnterPasswordEmpty
                                                              .value ||
                                                          _signUpController
                                                              .passwordEmpty
                                                              .value)
                                                  ? CustomBox(
                                                      color: Color(0xfff8d0c9),
                                                      child: InCorrectTextPopUp(
                                                        textChild: RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          'The fields can not ',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Color(0xff222222))),
                                                                  TextSpan(
                                                                      text:
                                                                          'be empty',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          height:
                                                                              2,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Color(0xff222222))),
                                                                ])),
                                                      ),
                                                    )
                                                  : (_signUpController.emailEmpty.value &&
                                                          _signUpController
                                                              .emailController
                                                              .text
                                                              .isNotEmpty &&
                                                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                              .hasMatch(_signUpController
                                                                  .emailController
                                                                  .text))
                                                      ? CustomBox(
                                                          color:
                                                              Color(0xfff8d0c9),
                                                          child:
                                                              InCorrectTextPopUp(
                                                            textChild: RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              'Enter valid ',
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color(0xff222222))),
                                                                      TextSpan(
                                                                          text:
                                                                              'email',
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              height: 2,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color(0xff222222))),
                                                                    ])),
                                                          ),
                                                        )
                                                      : (!_signUpController.numberValidator.value ||
                                                                  !_signUpController.lengthValidator.value ||
                                                                  !_signUpController.capitalLetterValidator.value ||
                                                                  !_signUpController.specialLetterValidator.value) &&
                                                              _signUpController.passwordController.text.isNotEmpty
                                                          ? CustomBox(
                                                              color: Color(
                                                                  0xfff8d0c9),
                                                              child:
                                                                  InCorrectTextPopUp(
                                                                textChild:
                                                                    RichText(
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        text: TextSpan(
                                                                            children: [
                                                                              TextSpan(text: 'The password should have\n', style: TextStyle(fontSize: 14, color: Color(0xff222222))),
                                                                              TextSpan(text: 'at least ', style: TextStyle(fontSize: 14, height: 2, color: Color(0xff222222))),
                                                                              TextSpan(text: '8 characters, 1 number\n', style: TextStyle(fontSize: 14, height: 2, color: Color(0xff222222), fontWeight: FontWeight.bold)),
                                                                              TextSpan(text: 'and ', style: TextStyle(height: 2, fontSize: 14, color: Color(0xff222222))),
                                                                              TextSpan(text: '1 special character.', style: TextStyle(fontSize: 14, color: Color(0xff222222), fontWeight: FontWeight.bold)),
                                                                            ])),
                                                              ),
                                                            )
                                                          : _signUpController.passwordsDonotMatch.value
                                                              ? CustomBox(
                                                                  color: Color(
                                                                      0xfff8d0c9),
                                                                  child:
                                                                      InCorrectTextPopUp(
                                                                          textChild:
                                                                              Text(
                                                                    "Passwords do not match.",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xff222222),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                                )
                                                              : SizedBox(),
                                              _signUpController.condition5
                                                              .value ==
                                                          false &&
                                                      _signUpController
                                                              .passwordsDonotMatch
                                                              .value ==
                                                          false
                                                  ? const SizedBox(height: 45)
                                                  : const SizedBox(height: 14),
                                              Button(
                                                onClick: _signUpController
                                                        .loading.value
                                                    ? null
                                                    : () {
                                                        if (_formKey
                                                            .currentState
                                                            .validate()) {
                                                          if (_signUpController.numberValidator.value &&
                                                              _signUpController
                                                                  .lengthValidator
                                                                  .value &&
                                                              _signUpController
                                                                  .capitalLetterValidator
                                                                  .value &&
                                                              _signUpController
                                                                  .specialLetterValidator
                                                                  .value &&
                                                              _signUpController
                                                                      .passwordsDonotMatch
                                                                      .value ==
                                                                  false) {
                                                            _signUpController
                                                                .condition5
                                                                .value = false;
                                                            _signUpController
                                                                .mapInput();
                                                            print('object');
                                                          } else if (!_signUpController.numberValidator.value &&
                                                              !_signUpController
                                                                  .lengthValidator
                                                                  .value &&
                                                              !_signUpController
                                                                  .capitalLetterValidator
                                                                  .value &&
                                                              !_signUpController
                                                                  .specialLetterValidator
                                                                  .value) {
                                                            print('object1');

                                                            _signUpController
                                                                .condition5
                                                                .value = true;
                                                          } else if (_signUpController
                                                              .passwordsDonotMatch
                                                              .value) {
                                                            _signUpController
                                                                .passwordsDonotMatch
                                                                .value = true;
                                                            print('object2');
                                                          } else if (!_signUpController
                                                                  .passwordsDonotMatch
                                                                  .value &&
                                                              _signUpController
                                                                  .numberValidator
                                                                  .value &&
                                                              _signUpController
                                                                  .lengthValidator
                                                                  .value &&
                                                              _signUpController
                                                                  .capitalLetterValidator
                                                                  .value &&
                                                              _signUpController
                                                                  .specialLetterValidator
                                                                  .value) {
                                                            print(
                                                                'else object2');
                                                            _signUpController
                                                                .mapInput();
                                                          }
                                                        } else {
                                                          print('else object');
                                                        }
                                                        return;
                                                      },
                                                          //till here
                                                child: _signUpController
                                                        .loading.value
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : Text(
                                                        'Continue',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16),
                                                      ),
                                                buttonColor: Color(0xff8bc34c),
                                                height: 44,
                                                buttonShape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Column(
                                                children: [
                                                  Center(
                                                      child: const Text(
                                                    'Or',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                                  SizedBox(height: 12),
                                                  Platform.isAndroid
                                                      ? Container(
                                                          height: 44,
                                                          width: 400,
                                                          child: _loginPageController
                                                                      .isLoading ==
                                                                  true
                                                              ? Center(
                                                                  child:
                                                                      CircularProgressIndicator())
                                                              : FloatingActionButton
                                                                  .extended(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 0,
                                                                  onPressed:
                                                                      () {
                                                                    _signUpController
                                                                        .analyticsService
                                                                        .logLogin(
                                                                            "Signup with google.");
                                                                    _loginPageController
                                                                        .loginGoogle(
                                                                            context);
                                                                  },
                                                                  label:
                                                                      const Text(
                                                                    "Sign up with Google",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff13253A),
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  icon: Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            0.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/google.png',
                                                                      width: 32,
                                                                      height:
                                                                          32,
                                                                    ),
                                                                  ),
                                                                ),
                                                        )
                                                      : Column(
                                                          children: [
                                                            _loginPageController
                                                                        .isLoadingApple ==
                                                                    true
                                                                ? Center(
                                                                    child:
                                                                        CircularProgressIndicator())
                                                                : SignInWithAppleButton(
                                                                    text:
                                                                        "Sign up with Apple",
                                                                    height: 46,
                                                                    iconAlignment:
                                                                        IconAlignment
                                                                            .center,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            24),
                                                                    onPressed:
                                                                        () {
                                                                      _signUpController
                                                                          .analyticsService
                                                                          .logLogin(
                                                                              "Signup with apple.");
                                                                      _loginPageController
                                                                          .signInWithApple(
                                                                              context);
                                                                    },
                                                                  ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 18),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Already have an account?',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              SizedBox(
                                                width: 14,
                                              ),
                                              InkWell(
                                                onTap: () => Get.offAll(
                                                    () => LoginPageView(),
                                                    binding:
                                                        LoginPageBinding()),
                                                child: Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Color(0xff8bc34c)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                  ]));
        }),
      ),
    );
  }

  // Widget passwordValidator() {
  //   return CustomBox(signUpController: _signUpController);
  // }

  Widget passwordField(String hintText, double textSize, Color textColor) {
    return TextFormField(
      autocorrect: false,
      controller: _signUpController.passwordController,
      obscureText: _signUpController.hidePassword.value ? true : false,
      obscuringCharacter: '*',
      validator: (text) {
        if (text.isEmpty) {
          _signUpController.passwordEmpty.value = true;
          _signUpController.condition5.value == true;

          return null;
        } else if (_signUpController.numberValidator.value &&
            _signUpController.lengthValidator.value &&
            _signUpController.capitalLetterValidator.value &&
            _signUpController.specialLetterValidator.value) {
          _signUpController.condition5.value == false;
          _signUpController.passwordEmpty.value = false;
          return null;
        } else {
          _signUpController.passwordEmpty.value = true;
          _signUpController.condition5.value == true;
          return null;
        }
      },
      decoration: InputDecoration(
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              width: _signUpController.passwordEmpty.value ? 1 : 0,
              color: Color(0xffce887b),
              style: _signUpController.passwordEmpty.value
                  ? BorderStyle.solid
                  : BorderStyle.none,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.none)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              width: 0,
              color: Colors.red,
              style: BorderStyle.none,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              _signUpController.showHidePassword();
            },
            child: _signUpController.hidePassword.value
                ? SvgPicture.asset(
                    "assets/svgs/eye.svg",
                    fit: BoxFit.scaleDown,
                  )
                : SvgPicture.asset(
                    "assets/svgs/eye-off.svg",
                    fit: BoxFit.scaleDown,
                  ),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: textColor),
          contentPadding: EdgeInsets.only(left: 20)),
      onTap: () {
        _signUpController.inputFieldFocused.value = true;
      },
      onChanged: (value) {
        if (_signUpController.passwordController.text.length >= 8)
          _signUpController.lengthValidator.value = true;
        else
          _signUpController.lengthValidator.value = false;

        if (RegExp(r'^(?=.*?[A-Z])')
            .hasMatch(_signUpController.passwordController.text))
          _signUpController.capitalLetterValidator.value = true;
        else
          _signUpController.capitalLetterValidator.value = false;

        if (RegExp(r'^(?=.*?[0-9])')
            .hasMatch(_signUpController.passwordController.text))
          _signUpController.numberValidator.value = true;
        else
          _signUpController.numberValidator.value = false;

        if (RegExp(r'^(?=.*?[!@#\$&*~])')
            .hasMatch(_signUpController.passwordController.text))
          _signUpController.specialLetterValidator.value = true;
        else
          _signUpController.specialLetterValidator.value = false;
      },
      onEditingComplete: () {
        FocusManager.instance.primaryFocus.unfocus();
        _signUpController.inputFieldFocused.value = false;
      },
      style: TextStyle(
        fontSize: textSize,
        color: textColor,
      ),
    );
  }

  Widget reEnterPasswordField(
      String hintText, double textSize, Color textColor) {
    return Obx(
      () => TextFormField(
        autocorrect: false,
        controller: _signUpController.reEnterPasswordController,
        obscureText: _signUpController.hideReEnterPassword.value ? true : false,
        obscuringCharacter: '*',
        validator: (text) {
          if (text.isEmpty) {
            _signUpController.reEnterPasswordEmpty.value = true;
            return null;
          } else if (text != _signUpController.passwordController.text) {
            _signUpController.passwordsDonotMatch.value = true;
            _signUpController.reEnterPasswordEmpty.value = true;
            return null;
          } else {
            _signUpController.passwordsDonotMatch.value = false;
            _signUpController.reEnterPasswordEmpty.value = false;
            return null;
          }
        },
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                width: (_signUpController.passwordsDonotMatch.value ||
                        _signUpController
                            .reEnterPasswordController.text.isEmpty ||
                        _signUpController.reEnterPasswordEmpty.value)
                    ? 1
                    : 0,
                color: Color(0xffce887b),
                style: _signUpController.passwordsDonotMatch.value ||
                        _signUpController.reEnterPasswordEmpty.value
                    ? BorderStyle.solid
                    : BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                width: 0,
                color: Colors.red,
                style: BorderStyle.none,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                _signUpController.showHideReEnterPassword();
              },
              child: _signUpController.hideReEnterPassword.value
                  ? SvgPicture.asset(
                      "assets/svgs/eye.svg",
                      fit: BoxFit.scaleDown,
                    )
                  : SvgPicture.asset(
                      "assets/svgs/eye-off.svg",
                      fit: BoxFit.scaleDown,
                    ),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: textColor),
            contentPadding: EdgeInsets.only(
              left: 20,
            )),
        onTap: () => _signUpController.inputFieldFocused.value = false,
        style: TextStyle(
          fontSize: textSize,
          color: textColor,
        ),
      ),
    );
  }

  Widget emailInputField(String hintText, double textSize, Color textColor) {
    return TextFormField(
      autocorrect: false,
      controller: _signUpController.emailController,
      validator: (text) {
        if (text.isEmpty) {
          _signUpController.emailEmpty.value = true;
          return null;
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(text)) {
          _signUpController.emailEmpty.value = true;
          return null;
        } else
          _signUpController.emailEmpty.value = false;

        return null;
      },
      onTap: () => _signUpController.inputFieldFocused.value = false,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            width: (_signUpController.emailEmpty.value) ? 1 : 0,
            color: Color(0xffce887b),
            style: _signUpController.emailEmpty.value
                ? BorderStyle.solid
                : BorderStyle.none,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            width: 0,
            color: Colors.red,
            style: BorderStyle.none,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: textColor),
        contentPadding: EdgeInsets.only(left: 20, right: 20),
      ),
      style: TextStyle(
        fontSize: textSize,
        color: textColor,
      ),
    );
  }
}

class InCorrectTextPopUp extends StatelessWidget {
  final Widget textChild;
  const InCorrectTextPopUp({
    Key key,
    this.textChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 36,
          width: 35,
          child: SvgPicture.asset('assets/svgs/x-circle.svg'),
        ),
        const SizedBox(height: 12),
        textChild,
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class CustomBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool paddingStatus;
  const CustomBox({
    Key key,
    @required this.child,
    this.color = Colors.white,
    this.paddingStatus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 2,
                  spreadRadius: 1,
                  color: Colors.grey.withOpacity(0.2))
            ]),
        padding: paddingStatus ? EdgeInsets.all(10) : EdgeInsets.zero,
        child: child);
  }
}

class passwordValidationWidget extends StatelessWidget {
  const passwordValidationWidget({Key key, this.status = false, this.content})
      : super(key: key);

  final bool status;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: status ? Color(0xff79c631) : Color(0xffd2cfcf),
                  shape: BoxShape.circle),
            ),
            SizedBox(
              width: 8,
            ),
            Text(content,
                style: TextStyle(
                  fontSize: 12,
                ))
          ],
        ),
        const SizedBox(height: 9),
      ],
    );
  }
}

//  (_signUpController
//                                                           .emailController.text.isEmpty &&
//                                                       _signUpController
//                                                           .passwordController
//                                                           .text
//                                                           .isEmpty &&
//                                                       _signUpController
//                                                           .reEnterPasswordController
//                                                           .text
//                                                           .isEmpty && )
//                                                   ? CustomBox(
//                                                       color: Color(0xfff8d0c9),
//                                                       child: InCorrectTextPopUp(
//                                                         textChild: RichText(
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                             text: TextSpan(
//                                                                 children: [
//                                                                   TextSpan(
//                                                                       text:
//                                                                           '''The fields can not ''',
//                                                                       style: TextStyle(
//                                                                           fontSize:
//                                                                               14,
//                                                                           color:
//                                                                               Color(0xff222222))),
//                                                                   TextSpan(
//                                                                       text:
//                                                                           'be empty.',
//                                                                       style: TextStyle(
//                                                                           fontSize:
//                                                                               14,
//                                                                           height:
//                                                                               2,
//                                                                           color:
//                                                                               Color(0xff222222))),
//                                                                 ])),
//                                                       ),
//                                                     )
//                                                   : 
