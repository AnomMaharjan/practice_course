import 'package:flutter/material.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/time_breakdown_model.dart';

class TimeBreakdownController extends BaseController with Connection {
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider();
  bool fetching = false;

  List<TimeBreakdownResponse> timeBreakdownList = [];
  List<TimeBreakdownResponse> filteredBreakdownList = [];

  List<Color> colors = [
    Color(0xffFF7B8E),
    Color(0xffBA9FE2),
    Color(0xff84E6F8),
    Color(0xff9ADD6F),
    Color(0xff6DD5CA),
    Color(0xfffff0b3),
    Color(0xffff6666),
    Color(0xffF0CBDB),
    Color(0xffCED56D),
    Color(0xffB86EAC),
    Color(0xffC66EA3),
    Color(0xffEAB6CC),
    Color(0xffff8666),
    Color(0xffb4d2ac),
    Color(0xff66b3ff),
    Color(0xff6DD5A8),
    Color(0xff956FD6),
    Color(0xff6D9AD5),
    Color(0xff9ADD6F),
    Color(0xff00E6F8),
    Color(0xff8FEA8C),
    Color(0xffBEEA8C),
    Color(0xff37D03F),
    Color(0xffB437D0),
    Color(0xff6737D0),
    Color(0xffF6A4C8),
    Color(0xffC5A4F6),
    Color(0xff9141A4),
    Color(0xffCDCACD),
    Color(0xff755210),
    Color(0xff068E50),
    Color(0xff06888E),
    Color(0xff2BB52A),
    Color(0xff77D518),
    Color(0xff67273C),
    Color(0xff8A6083),
    Color(0xff8A7C60),
    Color(0xff7B070E),
    Color(0xff173F44),
    Color(0xffEEA4F6),
  ];

  int touchedIndex = -1;
  bool showTable = false;
  double totalTime = 0;
  updateTouchedIndex(int index) {
    touchedIndex = index;
    update();
  }

  updateShowtableCondition() {
    showTable = !showTable;
    update();
  }

  void fetchTimeBreakDown() async {
    setState(ViewState.Busy);
    timeBreakdownList = await _apiAuthProvider.fetchTimeBreakdown();
    if (timeBreakdownList != null) {
      for (int i = 0; i < timeBreakdownList.length; i++) {
        if (timeBreakdownList[i].totalMinutesSaved != null &&
            timeBreakdownList[i].totalMinutesSaved != 0.0) {
          filteredBreakdownList.add(timeBreakdownList[i]);
          totalTime = totalTime + timeBreakdownList[i].totalMinutesSaved;
        }
      }
      update();
    }
    setState(ViewState.Retrieved);
    update();
  }

  BuildContext contexts;
  initialize(BuildContext context) {
    contexts = context;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchTimeBreakDown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }
}
