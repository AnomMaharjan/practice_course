import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q4me/app/components/top_card.dart';
import 'package:q4me/app/modules/sign_up/views/sign_up_view.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/widgets/button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  final _formKey = GlobalKey<FormState>();
  final LoginPageController _loginPageController =
      Get.put(LoginPageController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _loginPageController.initialize(context);
    double marginHeight;
    var size = MediaQuery.of(context).size;

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
        child: Obx(
          () => SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    TopCard(
                      height: Get.height * 0.35,
                      topColor: Color(0xff13253A),
                      bottomColor: Color(0xff13253A),
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
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/logo_slogan.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: Get.width,
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xff13253A),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                emailInputField("eg: email@email.com", 14,
                                    Color(0xff949594)),
                                const SizedBox(height: 16),
                                Text(
                                  'Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                passwordField(
                                    "eg: xxxxxx", 14, Color(0xff949594)),
                                SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.RESET_PASSWORD_PAGE);
                                  },
                                  child: Text('Forgot your password?',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300)),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                (_loginPageController.usernameController.text
                                                .isEmpty &&
                                            _loginPageController
                                                .errorEmail.value) ||
                                        (_loginPageController.passwordController
                                                .text.isEmpty &&
                                            _loginPageController
                                                .errorPassword.value)
                                    ? CustomBox(
                                        color: Color(0xfff8d0c9),
                                        child: InCorrectTextPopUp(
                                            textChild: Text(
                                          "Fields can't be empty",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff222222),
                                              fontWeight: FontWeight.bold),
                                        )),
                                      )
                                    : _loginPageController
                                                .errorPassword.value ||
                                            _loginPageController
                                                .errorEmail.value
                                        ? CustomBox(
                                            color: Color(0xfff8d0c9),
                                            child: InCorrectTextPopUp(
                                                textChild: Text(
                                              "${_loginPageController.errorText}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff222222),
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          )
                                        : SizedBox(),
                                const SizedBox(
                                  height: 30,
                                ),
                                Button(
                                  onClick: controller.state == ViewState.Busy
                                      ? null
                                      : () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            if (_loginPageController
                                                    .usernameController
                                                    .text
                                                    .isNotEmpty &&
                                                _loginPageController
                                                    .passwordController
                                                    .text
                                                    .isNotEmpty) {
                                              _loginPageController
                                                  .analyticsService
                                                  .logLogin("Email login");
                                              _loginPageController
                                                  .mapInputsLogin(context);
                                            }
                                          } else
                                            return;
                                        },
                                  child: controller.state == ViewState.Busy
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : const Text(
                                          'Continue',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                  buttonColor: Color(0xff8bc34c),
                                  height: 44,
                                  buttonShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Center(
                                        child: Text(
                                      'Or',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    const SizedBox(
                                      height: 12,
                                    ),
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
                                                : FloatingActionButton.extended(
                                                    backgroundColor:
                                                        Colors.white,
                                                    elevation: 0.2,
                                                    onPressed: () {
                                                      _loginPageController
                                                          .analyticsService
                                                          .logLogin(
                                                              "Login with google");
                                                      _loginPageController
                                                          .loginGoogle(context);
                                                    },
                                                    label: Text(
                                                      "Sign in with Google",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff13253A),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    icon: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 0.0),
                                                      child: Image.asset(
                                                        'assets/images/google.png',
                                                        width: 30,
                                                        height: 30,
                                                      ),
                                                    ),
                                                  ),
                                          )
                                        : Column(
                                            children: [
                                              _loginPageController
                                                          .isLoadingApple
                                                          .value ==
                                                      true
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : SignInWithAppleButton(
                                                      text:
                                                          "Sign in with Apple",
                                                      height: 44,
                                                      iconAlignment:
                                                          IconAlignment.center,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      onPressed: () {
                                                        _loginPageController
                                                            .analyticsService
                                                            .logLogin(
                                                                "Login with apple");
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
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                InkWell(
                                  onTap: () => Get.offAll(() => SignUpView()),
                                  child: Text(
                                    'Sign up',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
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
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget passwordField(String hintText, double textSize, Color textColor) {
    return TextFormField(
      autocorrect: false,
      controller: _loginPageController.passwordController,
      obscureText: _loginPageController.hidePassword.value ? true : false,
      obscuringCharacter: '*',
      validator: (text) {
        if (text.isEmpty) {
          _loginPageController.errorPassword.value = true;
          return null;
        } else
          return null;
      },
      onEditingComplete: () {
        _loginPageController.errorPassword.value = false;
        FocusManager.instance.primaryFocus.unfocus();
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              width: (_loginPageController.errorPassword.value) ? 1 : 0,
              color: Color(0xffce887b),
              style: _loginPageController.errorPassword.value
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
              _loginPageController.showHidePassword();
            },
            child: _loginPageController.hidePassword.value
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
      style: TextStyle(
        fontSize: textSize,
        color: textColor,
      ),
    );
  }

  Widget emailInputField(String hintText, double textSize, Color textColor) {
    return TextFormField(
      autocorrect: false,
      controller: _loginPageController.usernameController,
      validator: (text) {
        if (text.isEmpty) {
          _loginPageController.errorEmail.value = true;
          return null;
        } else
          return null;
      },
      onEditingComplete: () {
        _loginPageController.errorEmail.value = false;
        FocusManager.instance.primaryFocus.unfocus();
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              width: (_loginPageController.errorEmail.value) ? 1 : 0,
              color: Color(0xffce887b),
              style: _loginPageController.errorEmail.value
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
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: textColor),
          contentPadding: EdgeInsets.only(left: 20, right: 20)),
      style: TextStyle(
        fontSize: textSize,
        color: textColor,
      ),
    );
  }
}
