import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../controllers/privacy_policy_page_controller.dart';

class PrivacyPolicyPageView extends GetView<PrivacyPolicyPageController> {
  final PrivacyPolicyPageController _privacyPolicyPageController =
      Get.put(PrivacyPolicyPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Obx(
      //   () => homeController.state != ViewState.Busy
      //       ? Padding(
      //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //           child: Container(
      //             child: ListView.builder(
      //               shrinkWrap: true,
      //               itemCount: homeController.policies.length,
      //               itemBuilder: (context, index) {
      //                 return Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         homeController.policies[index]['heading'],
      //                         style: TextStyle(
      //                             fontSize: 20, fontWeight: FontWeight.w800),
      //                       ),
      //                       SizedBox(
      //                         height: 4,
      //                       ),
      //                       Text(
      //                         homeController.policies[index]['content'],
      //                         style: TextStyle(fontSize: 20),
      //                       ),
      //                       SizedBox(
      //                         height: 20,
      //                       )
      //                     ]);
      //               },
      //             ),
      //           ),
      //         )
      body: Center(
          child: Html(
        data: _privacyPolicyPageController.privacyPolicy[0].content,
      )
          // Text(_privacyPolicyPageController.privacyPolicy[0].content),
          ),
    );
  }
}
