import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
import 'package:q4me/app/modules/login_page/bindings/login_page_binding.dart';
import 'package:q4me/app/modules/login_page/views/login_page_view.dart';
import 'package:q4me/app/modules/setting_page/views/setting_page_view.dart';
import 'package:q4me/globals/globals.dart' as globals;
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key key, this.from}) : super(key: key);
  final int from;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14), topRight: Radius.circular(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: Offset(2, 0),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Obx(() => widget.from == 3
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      locator<SharedPreferencesManager>().getBool("isLogin")
                          ? Get.offAll(() => HomepageView(),
                              transition: Transition.noTransition)
                          : Get.offAll(() => LoginPageView(),
                              binding: LoginPageBinding());
                      // Navigator.popUntil(context, (route) => route.isFirst);
                      globals.currentIndex.value = 0;
                      globals.topupStatus.value = false;
                      print("value: ${globals.currentIndex.value}");
                    });
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      color: Colors.white,
                    ),
                    width: Get.width / 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: SvgPicture.asset(
                        widget.from == 3
                            ? 'assets/svgs/home1.svg'
                            : 'assets/svgs/home-light.svg',
                        height: 26,
                        width: 26,
                        color: widget.from == 3
                            ? Color(0xff162A43)
                            : Color(0xff162A43),
                        placeholderBuilder: (BuildContext context) =>
                            Container(child: const CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      locator<SharedPreferencesManager>().getBool("isLogin")
                          ? Get.offAll(() => SettingPageView(),
                              transition: Transition.noTransition)
                          : Get.offAll(() => LoginPageView(),
                              binding: LoginPageBinding());
                      // Navigator.popUntil(context, (route) => route.isFirst);
                      globals.currentIndex.value = 1;
                      globals.topupStatus.value = false;
                      print("value: ${globals.currentIndex.value}");
                    });
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      color: Colors.white,
                    ),
                    width: Get.width / 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: SvgPicture.asset(
                        globals.currentIndex.value == 1
                            ? 'assets/svgs/settings.svg'
                            : 'assets/svgs/settings-light.svg',
                        height: 26,
                        width: 26,
                        color: globals.currentIndex.value == 1
                            ? Color(0xff162A43)
                            : Color(0xff162A43),
                        placeholderBuilder: (BuildContext context) =>
                            Container(child: const CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: globals.currentIndex.value == 0
                      ? () {
                          setState(() {
                            globals.topupStatus.value = false;
                            globals.addCreditStatus.value = false;
                          });
                        }
                      : () {
                          setState(() {
                            Get.offAll(() => HomepageView(),
                                transition: Transition.noTransition);

                            // Navigator.popUntil(context, (route) => route.isFirst);
                            globals.currentIndex.value = 0;
                            globals.topupStatus.value = false;
                            globals.addCreditStatus.value = false;
                            print("value: ${globals.currentIndex.value}");
                          });
                        },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      color: Colors.white,
                    ),
                    width: Get.width / 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SvgPicture.asset(
                        'assets/svgs/home1.svg',
                        height: 26,
                        width: 26,
                        color: widget.from == 0
                            ? (globals.currentIndex.value == 0
                                ? Colors.grey.shade400
                                : Color(0xff162A43))
                            : (globals.currentIndex.value == 0
                                ? Colors.grey.shade400
                                : Color(0xff162A43)),
                        placeholderBuilder: (BuildContext context) =>
                            Container(child: const CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: globals.currentIndex.value == 1
                      ? null
                      : () {
                          setState(() {
                            Get.offAll(() => SettingPageView(),
                                transition: Transition.noTransition);

                            // Navigator.popUntil(context, (route) => route.isFirst);
                            globals.currentIndex.value = 1;
                            globals.topupStatus.value = false;
                            globals.addCreditStatus.value = false;
                            print("value: ${globals.currentIndex.value}");
                          });
                        },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      color: Colors.white,
                    ),
                    width: Get.width / 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SvgPicture.asset(
                        'assets/svgs/settings.svg',
                        height: 26,
                        width: 26,
                        color: widget.from == 0
                            ? (globals.currentIndex.value == 0
                                ? Color(0xff162A43)
                                : Colors.grey.shade400)
                            : (globals.currentIndex.value == 0
                                ? Colors.grey.shade400
                                : Colors.grey.shade400),
                        placeholderBuilder: (BuildContext context) =>
                            Container(child: const CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ),
              ],
            )),
    );
  }
}
