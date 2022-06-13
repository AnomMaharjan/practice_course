import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/add_credit_page/bindings/add_credit_page_binding.dart';
import 'package:q4me/app/modules/add_credit_page/views/add_credit_page_view.dart';
import 'package:q4me/app/modules/homepage/bindings/homepage_binding.dart';
import 'package:q4me/app/modules/homepage/controllers/homepage_controller.dart';
import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import 'package:q4me/widgets/reusable_button.dart';
import '../controllers/time_breakdown_controller.dart';
import 'package:q4me/globals/globals.dart' as globals;

class TimeBreakdownView extends GetView<TimeBreakdownController> {
  final int from;
  TimeBreakdownView({this.from});

  final TimeBreakdownController _timeBreakdownController =
      Get.put(TimeBreakdownController());
  final HomepageController homepageController = Get.put(HomepageController());

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _timeBreakdownController.initialize(context);
    Size size = MediaQuery.of(context).size;
    return GetBuilder<TimeBreakdownController>(
        builder: (builder) => Scaffold(
            backgroundColor: Color(0xff13253a),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  height: Platform.isIOS
                      ? Get.height < 684
                          ? Get.height
                          : Get.height -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top +
                              10
                      : Get.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top +
                          2,
                  child: Stack(
                    children: [
                      //if controller's state is busy, it shows loading widget.
                      _timeBreakdownController.state == ViewState.Busy
                          ? Container(
                              height: Get.height,
                              child: Center(child: CircularProgressIndicator()))
                          : _timeBreakdownController.timeBreakdownList == null
                              ? Center(
                                  child: Text(
                                      "Error has occured. Please check your network.",
                                      style: TextStyle(color: Colors.white)),
                                )
                              : _timeBreakdownController
                                      .filteredBreakdownList.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(height: 40),
                                          Image(
                                            image: AssetImage(
                                                "assets/images/Q_logo.png"),
                                            height: size.height < 684 ? 68 : 75,
                                          ),
                                          FittedBox(
                                            child: Text("Time Saved",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //checks if breakdown button is pressed or not. If pressed display tabular data otherwise display piechart

                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                "You haven't made any call yet...",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: 300,
                                                child: Stack(
                                                  children: [
                                                    //Shows piechart according to the time breakdown api data
                                                    Center(
                                                      child: Image(
                                                          image: AssetImage(
                                                              "assets/images/empty_pie_chart.png"),
                                                          height: 300,
                                                          width: 300),
                                                    ),
                                                    Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Total Time",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Text("0 Hrs",
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  color: Color(
                                                                      0xfa8BC34C),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                              ReusableButton(
                                                txt: Text("Make a Call",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                bgColor: Color(0xfa8BC34C),
                                                txtColor: Colors.white,
                                                onPressed: () {
                                                  globals.topupStatus.value =
                                                      false;

                                                  Get.offAll(
                                                      () => HomepageView(),
                                                      binding:
                                                          HomepageBinding());

                                                  globals.currentIndex.value =
                                                      0;
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ReusableButton(
                                                txt: Text("Add Credits",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xfa8BC34C),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                bgColor: Colors.white,
                                                txtColor: Colors.white,
                                                onPressed: () {
                                                  Get.to(
                                                      () => AddCreditPageView(),
                                                      binding:
                                                          AddCreditPageBinding(),
                                                      transition: Transition
                                                          .noTransition);

                                                  globals.currentIndex.value =
                                                      0;

                                                  globals.topupStatus.value =
                                                      true;
                                                  globals.addCreditStatus
                                                      .value = false;
                                                },
                                              ),
                                              SizedBox(
                                                height: 30,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(height: 40),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    "assets/images/Q_logo.png"),
                                                height:
                                                    size.height < 684 ? 68 : 75,
                                              ),
                                              Text("Time Saved",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        //checks if breakdown button is pressed or not. If pressed display tabular data otherwise display piechart
                                        _timeBreakdownController.showTable
                                            ? Expanded(
                                                flex: 9,
                                                child: tabularData(size))
                                            : Expanded(
                                                flex: 9,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Check out how much time\nyou’ve saved!",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Container(
                                                      height: 380,
                                                      child: Stack(
                                                        children: [
                                                          //Shows piechart according to the time breakdown api data
                                                          PieChart(
                                                            PieChartData(
                                                                pieTouchData: PieTouchData(
                                                                    touchCallback:
                                                                        (FlTouchEvent
                                                                                event,
                                                                            pieTouchResponse) {
                                                                  if (!event
                                                                          .isInterestedForInteractions ||
                                                                      pieTouchResponse ==
                                                                          null ||
                                                                      pieTouchResponse
                                                                              .touchedSection ==
                                                                          null) {
                                                                    _timeBreakdownController
                                                                        .updateTouchedIndex(
                                                                            -1);

                                                                    return;
                                                                  } else {
                                                                    _timeBreakdownController.updateTouchedIndex(pieTouchResponse
                                                                        .touchedSection
                                                                        .touchedSectionIndex);
                                                                    print(
                                                                        "touched: ${pieTouchResponse.touchedSection}");
                                                                    return showAlertDialog(
                                                                      context,

                                                                      _timeBreakdownController.filteredBreakdownList[_timeBreakdownController.touchedIndex].pieColor ==
                                                                              null
                                                                          ? null
                                                                          : _timeBreakdownController
                                                                              .filteredBreakdownList[_timeBreakdownController.touchedIndex]
                                                                              .pieColor,
                                                                      // _timeBreakdownController
                                                                      //         .colors[
                                                                      //     _timeBreakdownController
                                                                      //         .touchedIndex],
                                                                      _timeBreakdownController
                                                                          .filteredBreakdownList[_timeBreakdownController
                                                                              .touchedIndex]
                                                                          .totalMinutesSaved
                                                                          .toStringAsFixed(
                                                                              1),
                                                                      _timeBreakdownController
                                                                          .filteredBreakdownList[
                                                                              _timeBreakdownController.touchedIndex]
                                                                          .pieImage,
                                                                    );
                                                                  }
                                                                }),
                                                                sectionsSpace:
                                                                    4,
                                                                centerSpaceRadius:
                                                                    80,
                                                                startDegreeOffset:
                                                                    -20,
                                                                sections:
                                                                    pieChartSections()),
                                                          ),
                                                          Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Total Time",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(
                                                                    _timeBreakdownController.totalTime <
                                                                            60
                                                                        ? (_timeBreakdownController.totalTime).toStringAsFixed(1) +
                                                                            " Min"
                                                                        : (_timeBreakdownController.totalTime / 60).toStringAsFixed(1) +
                                                                            " Hrs",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            30,
                                                                        color: Color(
                                                                            0xfa8BC34C),
                                                                        fontWeight:
                                                                            FontWeight.w600))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    ReusableButton(
                                                      txt: Text("Break Down",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                      bgColor:
                                                          Color(0xfa8BC34C),
                                                      txtColor: Colors.white,
                                                      onPressed: () {
                                                        _timeBreakdownController
                                                            .updateShowtableCondition();
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 33,
                                                    )
                                                  ],
                                                ),
                                              )
                                      ],
                                    ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            splashRadius: 1,
                            onPressed: () {
                              if (_timeBreakdownController.showTable) {
                                _timeBreakdownController
                                    .updateShowtableCondition();
                              } else {
                                from == 0
                                    ? Get.offAll(() => HomepageView(),
                                        binding: HomepageBinding(),
                                        transition: Transition.noTransition)
                                    : Get.back();
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xfa8BC34C),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
                color: _timeBreakdownController.showTable
                    ? Color(0xfff2f2f2)
                    : Color(0xff13253a),
                child: BottomNavBar(from: 3))));
  }

//shows piechart sections
  List<PieChartSectionData> pieChartSections() {
    Color _colorFromHex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    return List.generate(_timeBreakdownController.filteredBreakdownList.length,
        (index) {
      Color color = _timeBreakdownController
                  .filteredBreakdownList[index].pieColor ==
              null
          ? null
          : _colorFromHex(
              _timeBreakdownController.filteredBreakdownList[index].pieColor);
      print(
          "color: ${_timeBreakdownController.filteredBreakdownList[index].pieColor}");
      return PieChartSectionData(
        color: _timeBreakdownController.filteredBreakdownList[index].pieColor !=
                null
            ? color
            : _timeBreakdownController.colors[index],
        value: _timeBreakdownController
            .filteredBreakdownList[index].totalMinutesSaved,
        showTitle: false,
        radius: 80,
      );
    });
  }

  Widget tabularData(var size) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        color: Color(0xfff2f2f2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text("Breakdown",
                style: TextStyle(
                    color: Color(0xff13253A),
                    fontSize: 30,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Text(
              "So far, your total time saved is\nlooking great!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff13253A)),
            ),
            SizedBox(
              height: 18,
            ),
            SizedBox(
              height: size.height < 684 ? 260 : 300,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Column(
                                children: List.generate(
                              _timeBreakdownController
                                      .filteredBreakdownList.length +
                                  1,
                              (index) => Column(
                                children: [
                                  index ==
                                          _timeBreakdownController
                                              .filteredBreakdownList.length
                                      ? Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                              color: Color(0xff182E4A),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Total Time",
                                                  style: TextStyle(
                                                      color: Color(0xff8BC34C),
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 38,
                                                width: 40,
                                                child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: Image(
                                                      image: NetworkImage(Config.baseUrl +
                                                          _timeBreakdownController
                                                              .filteredBreakdownList[
                                                                  index]
                                                              .dashboardImage),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                  SizedBox(
                                    height: 6,
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Column(
                              children: List.generate(
                                  _timeBreakdownController
                                          .filteredBreakdownList.length +
                                      1,
                                  (index) => Column(
                                        children: [
                                          index ==
                                                  _timeBreakdownController
                                                      .filteredBreakdownList
                                                      .length
                                              ? Container(
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff182E4A),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child: Center(
                                                    child: Text(
                                                      _timeBreakdownController
                                                                  .totalTime <
                                                              60
                                                          ? (_timeBreakdownController
                                                                      .totalTime)
                                                                  .toStringAsFixed(
                                                                      1) +
                                                              " Min"
                                                          : (_timeBreakdownController
                                                                          .totalTime /
                                                                      60)
                                                                  .toStringAsFixed(
                                                                      1) +
                                                              " Hrs",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff8BC34C),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child: Center(
                                                    child: Text(
                                                        _timeBreakdownController
                                                                    .filteredBreakdownList[
                                                                        index]
                                                                    .totalMinutesSaved <
                                                                60
                                                            ? _timeBreakdownController
                                                                    .filteredBreakdownList[
                                                                        index]
                                                                    .totalMinutesSaved
                                                                    .toStringAsFixed(
                                                                        1) +
                                                                " Min"
                                                            : (_timeBreakdownController
                                                                            .filteredBreakdownList[
                                                                                index]
                                                                            .totalMinutesSaved /
                                                                        60)
                                                                    .toStringAsFixed(
                                                                        1) +
                                                                " Hrs",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff13253A),
                                                            fontSize: 16)),
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String color, String dashboardTimeSaved,
      String dashboardImage) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  Config.baseUrl + dashboardImage,
                  scale: 2,
                ),
                fit: BoxFit.cover),
            color:
                Color(int.parse('FF${color.replaceAll('#', '')}', radix: 16)),
            borderRadius: BorderRadius.circular(20)),
        height: 260,
        width: 200,
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: Color(0xffffffff),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
                Text(
                  "You Saved\n$dashboardTimeSaved minutes.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                SizedBox(height: 28),
              ],
            ),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return alert;
      },
    );
  }
}
