import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:q4me/app/modules/home/views/privacy_policy_view.dart';
import 'package:q4me/app/modules/tour_screen/views/tour_screen_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Color(0xff13253a)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Privacy Policy Notice',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff13253A),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          // width: 80,
                          child: Divider(
                            color: Color(0xff8BC34C),
                            thickness: 3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 8.0),
                          child: Text(
                            'In order to improve your Q4ME experience, we collect some personal information. Your privacy is very important to us and we have developed a policy to help you understand how we handle your personal information. By accepting, you agree to the terms in our Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, height: 1.6, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(children: [
                    Divider(
                      thickness: 1,
                      height: 0,
                    ),
                    IntrinsicHeight(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            MaterialButton(
                              onPressed: () {
                                Get.to(() => PrivacyPolicyView());
                              },
                              child: Text(
                                'Read More',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff13253A),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: VerticalDivider(
                                thickness: 1,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Get.to(() => TourScreenView());
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xff8BC34C),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(),
                          ]),
                    ),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
