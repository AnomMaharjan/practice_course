import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import 'package:q4me/utils/string.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';

import '../controllers/configuration_page_controller.dart';

class ConfigurationPageView extends GetView<ConfigurationPageController> {
  final ConfigurationPageController _configurationPageController =
      Get.put(ConfigurationPageController());
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _configurationPageController.initialize(context);
    return Obx(
      () => Opacity(
        opacity: _configurationPageController.opacity.value,
        child: Scaffold(
          bottomNavigationBar: BottomNavBar(
            from: 3,
          ),
          backgroundColor: Color(0xfff2f2f2),
          body: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Center(
                          child: Text(
                            "Configurations",
                            style: TextStyle(
                                fontSize: 26,
                                color: GLOBAL_THEME_COLOR,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text('Option',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff222222),
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Auto-Retry",
                                    style: TextStyle(
                                      height: 1.6,
                                      color: Color(0xff222222),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Q4ME will try to reconnect to the service provider until the call is success.",
                                    style: TextStyle(
                                      color: Color(0xff222222),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24),
                                child: Obx(
                                  () => FlutterSwitch(
                                    value: _configurationPageController
                                        .autoRetryStatus.value,
                                    inactiveText: "OFF",
                                    activeText: "ON",
                                    showOnOff: true,
                                    height: 33,
                                    padding: 1.5,
                                    toggleSize: 33,
                                    width: 67,
                                    inactiveColor: Color(0xffd2cfcf),
                                    valueFontSize: 12,
                                    activeTextColor: Colors.white,
                                    inactiveTextColor: Colors.white,
                                    activeColor: Color(0xff8bc34c),
                                    onToggle: (value) {
                                      _configurationPageController
                                          .enableRetry();
                                    },
                                    activeTextFontWeight: FontWeight.normal,
                                    inactiveTextFontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Notification",
                                    style: TextStyle(
                                      height: 1.6,
                                      color: Color(0xff222222),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Q4ME will notify you about call connectivity, time saved and other details",
                                    style: TextStyle(
                                      color: Color(0xff222222),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24),
                                child: Obx(
                                  () => FlutterSwitch(
                                    value: _configurationPageController
                                        .notificationStatus.value,
                                    inactiveText: "OFF",
                                    activeText: "ON",
                                    showOnOff: true,
                                    height: 33,
                                    padding: 1.5,
                                    toggleSize: 33,
                                    width: 67,
                                    inactiveColor: Color(0xffd2cfcf),
                                    valueFontSize: 12,
                                    activeTextColor: Colors.white,
                                    inactiveTextColor: Colors.white,
                                    activeColor: Color(0xff8bc34c),
                                    onToggle: (value) {
                                      AppSettings.openNotificationSettings();
                                    },
                                    activeTextFontWeight: FontWeight.normal,
                                    inactiveTextFontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          splashRadius: 1,
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.arrow_back_ios),
                          color: GLOBAL_GREEN_COLOR),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
