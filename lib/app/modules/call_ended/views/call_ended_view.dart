import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/login_page/bindings/login_page_binding.dart';
import 'package:q4me/app/modules/login_page/views/login_page_view.dart';
import 'package:q4me/app/modules/time_breakdown/bindings/time_breakdown_binding.dart';
import 'package:q4me/app/modules/time_breakdown/views/time_breakdown_view.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import 'package:q4me/widgets/ripple.dart';
import '../controllers/call_ended_controller.dart';

class CallEndedView extends GetView<CallEndedController> {
  final String imageName;
  final String minutesSaved;
  CallEndedView({this.imageName, this.minutesSaved});
  final CallEndedController _callEndedController =
      Get.put(CallEndedController());

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    Future<bool> _onWillPop() {
      return Get.offAllNamed(Routes.INIT_PAGE) ?? false;
    }

    var size = MediaQuery.of(context).size;
    var time = minutesSaved.split(" ");
    var firstPart = time[0].trim();
    var secondPart = time.sublist(1).join(' ').trim();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar:
            Container(color: GLOBAL_THEME_COLOR, child: BottomNavBar(from: 3)),
        body: GetBuilder<CallEndedController>(
            init: _callEndedController.cont(context),
            builder: (context) {
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                    decoration: BoxDecoration(
                        color: GLOBAL_THEME_COLOR,
                        image: DecorationImage(
                            image: AssetImage(
                          "assets/images/confetti.gif",
                        ))),
                    height: Get.height,
                    width: Get.width,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: Get.height * 0.1),
                                child: Column(
                                  children: [
                                    RipplesAnimation(
                                      imageName: imageName,
                                      child: SizedBox(),
                                    ),
                                    SizedBox(height: 32),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _callEndedController.dialogue(),
                              child: Text(
                                'Call Ended!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'You just avoided waiting\n on hold for',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.6,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: "${firstPart}\n",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 78,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${secondPart}".toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ])),
                                SizedBox(height: 32),
                                SizedBox(
                                    height: 70,
                                    width: 66,
                                    child:
                                        SvgPicture.asset("assets/svgs/Q.svg")),
                              ],
                            )
                          ],
                        ),
                        Positioned(
                          top: Platform.isIOS
                              ? size.height < 684
                                  ? 16
                                  : 36
                              : 10,
                          left: 10,
                          child: IconButton(
                            splashRadius: 1,
                            onPressed: () => locator<SharedPreferencesManager>()
                                            .getBool("isLogin") ==
                                        true ||
                                    locator<SharedPreferencesManager>()
                                        .isKeyExists("isLogin")
                                ? Get.off(
                                    () => TimeBreakdownView(
                                          from: 0,
                                        ),
                                    binding: TimeBreakdownBinding())
                                : Get.offAll(() => LoginPageView(),
                                    binding: LoginPageBinding()),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xff8BC34C),
                            ),
                          ),
                        )
                      ],
                    )),
              );
            }),
      ),
    );
  }
}
