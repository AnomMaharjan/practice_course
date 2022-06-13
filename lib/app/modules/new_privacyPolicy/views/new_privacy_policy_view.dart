import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/widgets/CustomExpansionTile.dart';

import '../../../../utils/string.dart';
import '../controllers/new_privacy_policy_controller.dart';

class NewPrivacyPolicyView extends GetView<NewPrivacyPolicyController> {
  final NewPrivacyPolicyController _newPrivacyPolicyController =
      Get.put(NewPrivacyPolicyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GLOBAL_THEME_COLOR,
      appBar: Platform.isAndroid
          ? AppBar(
              elevation: 0,
              toolbarHeight: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: GLOBAL_THEME_COLOR,
                  statusBarBrightness: Brightness.dark),
            )
          : null,
      body: Obx(
        () => _newPrivacyPolicyController.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator.adaptive())
            : ListView(
                shrinkWrap: true,
                children: [
                  GetBuilder<NewPrivacyPolicyController>(builder: (_) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            splashRadius: 1,
                            padding: const EdgeInsets.only(left: 18, top: 27),
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back_ios),
                            color: const Color(0xff8BC34C),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                _newPrivacyPolicyController
                                    .privacyPolicyData[0].title,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 334,
                                width: 331,
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 27),
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/privacy_policy.png'))),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    "Last updated:  " +
                                        DateFormat.MMMM()
                                            .format(_newPrivacyPolicyController
                                                .privacyPolicyData[0].updatedAt)
                                            .toString() +
                                        " " +
                                        DateFormat.d()
                                            .format(_newPrivacyPolicyController
                                                .privacyPolicyData[0].updatedAt)
                                            .toString() +
                                        ", " +
                                        DateFormat.y()
                                            .format(_newPrivacyPolicyController
                                                .privacyPolicyData[0].updatedAt)
                                            .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      !_newPrivacyPolicyController.morePressed
                                          ? 205
                                          : null,
                                  padding: EdgeInsets.only(
                                      left: 12, right: 10, top: 0),
                                  child: Html(
                                      data: _newPrivacyPolicyController
                                          .privacyPolicyData[0].content),
                                ),
                                // Text(
                                //   _newPrivacyPolicyController
                                //   .privacyPolicyData[0].content,
                                //   style: const TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 16,
                                //       height: 1.8),
                                // ),
                                const SizedBox(height: 10),
                                MaterialButton(
                                  minWidth: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  onPressed: () =>
                                      _newPrivacyPolicyController.morePress(),
                                  child: Text(
                                    _newPrivacyPolicyController.morePressed
                                        ? 'Less'
                                        : 'More',
                                    style: TextStyle(
                                      color: GLOBAL_GREEN_COLOR,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ],
                    );
                  }),
                  Column(
                    children: List.generate(
                      _newPrivacyPolicyController.privacyPolicyData.length - 1,
                      (index) => CustomFaqExpansinoTile(
                        title: _newPrivacyPolicyController
                            .privacyPolicyData[index + 1].title,
                        contents: _newPrivacyPolicyController
                            .privacyPolicyData[index + 1].content,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
