import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import 'package:q4me/widgets/button.dart';
import 'package:q4me/widgets/ripple.dart';
import '../controllers/call_tracker_controller.dart';
import 'package:q4me/globals/globals.dart' as globals;

class CallTrackerView extends GetView<CallTrackerController> {
  final String imageName;

  CallTrackerView({this.imageName});

  final CallTrackerController _callTrackerController = Get.put(
    CallTrackerController(),
  ); //call tracker controller
  final CarouselController buttonCarouselController =
      CarouselController(); //button carousel controller

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _callTrackerController.initialize(context);
    final Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        await _callTrackerController.getNetworkStatus();
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(19, 37, 58, 1),
        bottomNavigationBar: BottomNavBar(from: 3),
        body: GetBuilder<CallTrackerController>(
          autoRemove: false,
          builder: (_) => locator<SharedPreferencesManager>()
                      .getBool("callGoing") ==
                  false
              ? Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            stops: [
                              0,
                              1
                            ],
                            colors: [
                              Color.fromRGBO(19, 37, 58, 1),
                              Color.fromRGBO(19, 37, 58, 0.8),
                            ]),
                      ),
                      height: Get.height,
                      width: Get.width,
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xfff2f2f2),
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.width * 0.65,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xff8bc34c),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No Ongoing Call",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Make a call to start tracking!",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(height: 28),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Button(
                                onClick: () {
                                  Get.offAll(() => HomepageView(),
                                      transition: Transition.noTransition);
                                  globals.currentIndex.value = 0;
                                  globals.topupStatus.value = false;
                                  globals.addCreditStatus.value = false;
                                },
                                child: Text(
                                  "Make your Call",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xfff2f2f2),
                                  ),
                                ),
                                buttonColor: Color(0xff8bc34c),
                                buttonShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                    Padding(
                      padding: size.height > 736
                          ? EdgeInsets.only(
                              top: Platform.isIOS ? 32.0 : 0,
                              left: Platform.isAndroid ? 8.0 : 8,
                            )
                          : const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: _callTrackerController.from == 1
                              ? () => Get.back()
                              : () {
                                  globals.currentIndex.value = 0;
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                          icon: Icon(Icons.arrow_back_ios,
                              color: Color(0xff8bc34c)),
                        ),
                      ),
                    ),
                  ],
                )
              : _callTrackerController.firstLoad == true
                  ? _callTrackerController.from == 1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              size.height > 736
                                  ? SizedBox(height: 32)
                                  : SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, top: 15),
                                    child: IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(Icons.arrow_back_ios,
                                          color: Color(0xff8bc34c)),
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              ),
                              callTrackerTitle(),
                              SizedBox(height: 300),
                              Center(child: CircularProgressIndicator()),
                              SizedBox(height: 30),
                            ])
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              size.height > 736
                                  ? SizedBox(height: 32)
                                  : SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, top: 15),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
                                      },
                                      splashRadius: 1,
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Color(0xff8BC34C),
                                      ),
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              ),
                              callTrackerTitle(),
                              // SizedBox(height: 30),
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    child: Stack(
                                      children: [
                                        Image.asset("assets/images/3.png"),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 65,
                                    left: 45,
                                    child: RipplesAnimation(
                                      imageName: imageName,
                                      child: SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 30),
                              MaterialButton(
                                padding: EdgeInsets.symmetric(horizontal: 60),
                                onPressed: _callTrackerController.canceling ==
                                        true
                                    ? null
                                    : () {
                                        _callTrackerController.cancelTimer();
                                        _callTrackerController.endCall();
                                      },
                                disabledColor: Color(0xff0F0030),
                                color: Color(0xffBF4E30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22)),
                                child: _callTrackerController.canceling == true
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Cancel The Call",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                height: 44,
                              ),
                              SizedBox(height: 30),
                              _callTrackerController.didYouKnows == null
                                  ? SizedBox()
                                  : Align(
                                      alignment: Alignment.bottomCenter,
                                      child: carouselSlider2(context))
                            ])
                  : _callTrackerController.callStatusModel.isRetrying
                      ? Stack(
                          children: [
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Color(0xff13253A),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Center(
                                          child: RipplesAnimation(
                                        imageName: _callTrackerController
                                            .callStatusModel.imageUrl,
                                        child: SizedBox(),
                                      )),
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
                                SizedBox(height: Get.height * 0.15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 55),
                                  child: MaterialButton(
                                    minWidth: Get.width,
                                    onPressed:
                                        _callTrackerController.canceling == true
                                            ? null
                                            : () {
                                                _callTrackerController
                                                    .cancelTimer();
                                                _callTrackerController
                                                    .endCall();
                                              },
                                    disabledColor: Color(0xff0F0030),
                                    color: GLOBAL_GREEN_COLOR,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    height: 44,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                            Padding(
                              padding: Platform.isIOS
                                  ? Get.height > 684
                                      ? EdgeInsets.only(top: 32.0)
                                      : EdgeInsets.only(top: 8)
                                  : EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(Icons.arrow_back_ios,
                                      color: Color(0xff8bc34c)),
                                ),
                              ),
                            )
                          ],
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              // height: Get.height,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    stops: [
                                      0,
                                      1
                                    ],
                                    colors: [
                                      Color.fromRGBO(19, 37, 58, 1),
                                      Color.fromRGBO(19, 37, 58, 0.8),
                                    ]),
                              ),
                              child: Column(
                                mainAxisAlignment: size.height > 684
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: IconButton(
                                            splashRadius: 1,
                                            onPressed:
                                                _callTrackerController.from == 1
                                                    ? () => Get.back()
                                                    : () {
                                                        Navigator.popUntil(
                                                            context,
                                                            (route) =>
                                                                route.isFirst);
                                                      },
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: Color(0xff8BC34C),
                                            )),
                                      ),
                                      SizedBox(),
                                    ],
                                  ),
                                  callTrackerTitle(),
                                  SizedBox(height: 20),
                                  Stack(
                                    children: [
                                      _callTrackerController.callStatusModel
                                                      .callStatus ==
                                                  "setting_up_call" &&
                                              _callTrackerController.state ==
                                                  ViewState.Busy
                                          ? Container(
                                              child: Stack(
                                              children: [
                                                Image.asset(
                                                    "assets/images/3.png"),
                                                Positioned(
                                                    top: 45,
                                                    left: 45,
                                                    child: RipplesAnimation(
                                                        imageName: imageName,
                                                        child: SizedBox())),
                                              ],
                                            ))
                                          : Container(
                                              child: Stack(
                                                children: [
                                                  _callTrackerController
                                                              .callStatusModel
                                                              .callStatus ==
                                                          "connecting_you"
                                                      ? Image.asset(
                                                          "assets/images/2.png")
                                                      : SizedBox(),
                                                  _callTrackerController
                                                              .callStatusModel
                                                              .callStatus ==
                                                          "setting_up_call"
                                                      ? Image.asset(
                                                          "assets/images/3.png")
                                                      : SizedBox(),
                                                  _callTrackerController
                                                              .callStatusModel
                                                              .callStatus ==
                                                          "waiting_on_hold"
                                                      ? Image.asset(
                                                          "assets/images/4.png")
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                      Positioned(
                                          top: 45,
                                          left: 45,
                                          child: RipplesAnimation(
                                              imageName: _callTrackerController
                                                  .callStatusModel.imageUrl,
                                              child: SizedBox())),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  _callTrackerController
                                              .callStatusModel.callStatus ==
                                          "connecting_you"
                                      ? SizedBox()
                                      : MaterialButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 60),
                                          onPressed: _callTrackerController
                                                      .canceling ==
                                                  true
                                              ? null
                                              : () {
                                                  _callTrackerController
                                                      .cancelTimer();
                                                  _callTrackerController
                                                      .endCall();
                                                },
                                          disabledColor: Color(0xff0F0030),
                                          color: Color(0xffBF4E30),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22)),
                                          child: Text(
                                            "Cancel The Call",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          height: 44,
                                        ),
                                  SizedBox(height: 30),
                                ],
                              ),
                            ),
                            _callTrackerController.didYouKnows == null
                                ? SizedBox()
                                : carouselSlider2(context),
                          ],
                        ),
        ),
      ),
    );
  }

  Widget callTrackerTitle() {
    return Text(
      "Call Tracker",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 46,
      ),
    );
  }

  Widget carouselSlider2(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: _callTrackerController.didYouKnows.length,
      options: CarouselOptions(
          autoPlay: true,
          height: 140.0,
          onPageChanged: (index, reason) {
            _callTrackerController.currentPosition = index;
            _callTrackerController.update();
            print("postion: ${_callTrackerController.currentPosition}");
          }),
      itemBuilder: (context, index, i) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
            // height: 20,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: index != _callTrackerController.currentPosition
                    ? Color(0xfff2f2f2).withOpacity(0.31)
                    : Color(0xfff2f2f2)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Did you know?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff13253a)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _callTrackerController.didYouKnows[index].content,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff222222)),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
