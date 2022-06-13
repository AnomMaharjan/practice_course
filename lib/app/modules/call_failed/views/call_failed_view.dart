import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import 'package:q4me/widgets/ripple.dart';
import '../controllers/call_failed_controller.dart';

class CallFailedView extends GetView<CallFailedController> {
  final String from;

  CallFailedView({this.from});
  final CallFailedController callFailedController =
      Get.put(CallFailedController());

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    callFailedController.initialize(context);
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        from: 3,
      ),
      backgroundColor: GLOBAL_THEME_COLOR,
      body: GetBuilder<CallFailedController>(
        builder: (builder) => Obx(() => ListView(
              shrinkWrap: true,
              children: [
                callFailedController.retrying.value
                    ? Stack(
                        children: [
                          Container(
                            width: Get.width,
                            height: Get.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Center(
                                        child: RipplesAnimation(
                                          imageName: callFailedController
                                              .callStatusModel.imageUrl,
                                          child: SizedBox(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Re-Connecting\nYour Call",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: Get.height * 0.1,
                                ),
                                SvgPicture.asset(
                                  "assets/svgs/call_failed.svg",
                                  height: 110,
                                  width: 110,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 11),
                                Text('Call Failed!',
                                    style: TextStyle(
                                        fontSize: 26,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  "Oops! Something went\nwrong. Your call could not\nbe connected.",
                                  style: TextStyle(
                                    height: 1.6,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: Get.height * 0.3,
                                ),
                                Text(
                                  "Would you like to retry?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      height: 1.63,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 26,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.1),
                                  child: Obx(
                                    () => callFailedController.loading.value ==
                                            true
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                flex: 6,
                                                child: MaterialButton(
                                                  disabledTextColor:
                                                      Color(0xffD2CFCF),
                                                  height: 44,
                                                  textColor: GLOBAL_GREEN_COLOR,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60)),
                                                  onPressed: () {
                                                    from == "terminated"
                                                        ? locator<SharedPreferencesManager>()
                                                                .getBool(
                                                                    "isLogin")
                                                            ? Get.offAllNamed(
                                                                Routes.HOMEPAGE)
                                                            : Get.offAllNamed(
                                                                Routes
                                                                    .LOGIN_PAGE)
                                                        : locator<SharedPreferencesManager>()
                                                                .getBool(
                                                                    "isLogin")
                                                            ? Navigator.popUntil(
                                                                context,
                                                                (route) => route
                                                                    .isFirst)
                                                            : Get.offAllNamed(
                                                                Routes
                                                                    .LOGIN_PAGE);
                                                    locator<SharedPreferencesManager>()
                                                        .putBool(
                                                            'callGoing', false);
                                                  },
                                                  disabledColor: Colors.white,
                                                  color: Colors.white,
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1, child: SizedBox()),
                                              Expanded(
                                                flex: 6,
                                                child: Obx(
                                                  () => MaterialButton(
                                                    disabledTextColor:
                                                        Color(0xffD2CFCF),
                                                    height: 44,

                                                    textColor: Colors.white,
                                                    // minWidth: Get.width / 2,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        60)),
                                                    onPressed: callFailedController
                                                                .loading
                                                                .value ==
                                                            true
                                                        ? null
                                                        : locator<SharedPreferencesManager>()
                                                                .getBool(
                                                                    "isLogin")
                                                            ? () {
                                                                callFailedController
                                                                    .retryCall();
                                                              }
                                                            : () => Get
                                                                .offAllNamed(Routes
                                                                    .LOGIN_PAGE),
                                                    disabledColor: Colors.white,
                                                    color: GLOBAL_GREEN_COLOR,
                                                    child: callFailedController
                                                                .loading
                                                                .value ==
                                                            true
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  splashRadius: 1,
                                  onPressed: from != "terminated"
                                      ? locator<SharedPreferencesManager>()
                                              .getBool("isLogin")
                                          ? () {
                                              locator<SharedPreferencesManager>()
                                                  .putBool('callGoing', false);
                                              Get.offAll(() => HomepageView());
                                            }
                                          : () {
                                              Get.offAll(Routes.LOGIN_PAGE);
                                            }
                                      : locator<SharedPreferencesManager>()
                                              .getBool("isLogin")
                                          ? () {
                                              Get.offAll(() => HomepageView());
                                              locator<SharedPreferencesManager>()
                                                  .putBool('callGoing', false);
                                            }
                                          : () {
                                              Get.offAll(Routes.LOGIN_PAGE);
                                            },
                                  icon: Icon(Icons.arrow_back_ios),
                                  color: GLOBAL_GREEN_COLOR),
                            ),
                          )
                        ],
                      ),
              ],
            )),
      ),
    );
  }
}
