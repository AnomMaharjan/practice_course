import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:q4me/app/modules/home/controllers/home_controller.dart';
import 'package:q4me/constants/enum.dart';

class PrivacyPolicyView extends GetView {
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
              fontSize: 20,
              color: Color(0xff13253A),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => homeController.state != ViewState.Busy
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: homeController.policies.length,
                    itemBuilder: (context, index) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              homeController.policies[index]['heading'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              homeController.policies[index]['content'],
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ]);
                    },
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
