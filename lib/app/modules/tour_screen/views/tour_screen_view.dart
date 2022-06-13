import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:q4me/app/modules/login_page/bindings/login_page_binding.dart';
import 'package:q4me/app/modules/login_page/views/login_page_view.dart';
import 'package:q4me/constants/enum.dart';

import '../controllers/tour_screen_controller.dart';
import 'package:introduction_screen/introduction_screen.dart';

class TourScreenView extends GetView<TourScreenController> {
  final TourScreenController _tourScreenController =
      Get.put(TourScreenController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: IntroductionScreen(
        scrollPhysics: ClampingScrollPhysics(),
        showNextButton: false,
        showDoneButton: false,
        dotsDecorator: DotsDecorator(
          activeColor: Color(0xff8bc34c),
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(16.0, 16.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        globalHeader: Padding(
          padding: Platform.isIOS
              ? EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: size.height < 684 ? 10.0 : 34.0)
              : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {
                  Get.to(() => LoginPageView(),binding: LoginPageBinding() );
                },
                minWidth: 0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                child: Text(
                  'SKIP',
                  style: TextStyle(
                      color: Color(0xff8BC34C),
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
        rawPages: [
          tourWidget1(
            "assets/images/tour_screen_1.png",
            'Warren Buffet',
            """People are going to want your time. 
It’s the only thing you can’t buy. 
I mean I can buy anything I want, 
basically, but I can’t buy time""",
          ),
          tourWidget2(
              "assets/images/tour_screen_2.png",
              'Why Q4ME ?',
              """Time is precious.
Enjoy the time you've got.
Start saving it today.""",
              """Q4ME calls for you so you can enjoy your time.""",
              """Say goodbye to waiting on hold."""),
          tourWidget3(
              "assets/images/tour_screen_3.png",
              'What Do You Need\nTo Do?',
              'Select who you want us to call on your behalf.',
              """You'll automatically get a call as soon as an actual human answers at the other end.""",
              """Simples."""),
        ],
      ),
    );
  }

  Widget tourWidget1(String image, String title, String content) {
    return Obx(() => Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            color: Color(0xff13253a),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tourScreenController.state == ViewState.Busy
                  ? Center(child: CircularProgressIndicator())
                  : Image.asset(
                      "assets/images/tour_screen_1.png",
                      height: 240,
                      fit: BoxFit.contain,
                    ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      _tourScreenController.firsttext.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, height: 1.6, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 120,
                    child: Divider(
                      color: Colors.white,
                      thickness: 3,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget tourWidget2(String image, String title, String content1,
      String content2, String content3) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        color: Color(0xff13253a),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo_slogan.png",
            height: 200,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                height: 2,
                fontWeight: FontWeight.w800,
                fontSize: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              " Time is precious.\nEnjoy the time you've got.\nStart saving it today.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  height: 1.6,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Q4ME calls for you so you\ncan enjoy your time.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  height: 2,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              " Say goodbye to waiting\non hold.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  height: 1.6,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget tourWidget3(String image, String title, String content1,
      String content2, String content3) {
    return Obx(
      () => Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          color: Color(0xff13253a),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/tour_screen_3.png",
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _tourScreenController.thirdtext.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                height: 1.5,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              minWidth: 270,
              height: 44,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              color: Color(0xff8bc34c),
              onPressed: () {
                Get.to(() => LoginPageView(), binding: LoginPageBinding());
              },
              child: Text(
                "Continue",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
