import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/call_status_model.dart';
import 'package:q4me/model/did_you_know_model.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';

class CallTrackerController extends BaseController with Connection {
  int id = locator<SharedPreferencesManager>().getInt('userID');
  final ApiAuthProvider apiAuthProvider = ApiAuthProvider();
  bool firstLoad = true;
  bool canceling = false;
  int from;
  int count = 0;
  List<DidYouKnow> didYouKnows;
  Timer _timer;
  CallStatusModel callStatusModel;
  int currentPosition = 0;

//To fetch did you know contents in call tracker page
  void fetchDidYouKnow() async {
    setState(ViewState.Busy);
    didYouKnows = await apiAuthProvider.fetchDidYouKnow();
    if (didYouKnows == null) {
      setState(ViewState.Retrieved);
      return null;
    }
    setState(ViewState.Retrieved);
  }

//End the ongoing call
  void endCall() async {
    canceling = true;
    bool ended = await apiAuthProvider.performCallEnd(id);
    if (ended) {
      canceling = false;
      Get.snackbar('Call cancelled!', 'You cancelled the call',
          margin: EdgeInsets.only(top: 20),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xfff2f2f2));
      locator<SharedPreferencesManager>().clearKey('callTrackerImage');
      locator<SharedPreferencesManager>().putBool(
          'callGoing', false); //sets the global variable callGoing to false.
      update();
    }
    canceling = false;
    update();
  }

//Starts the timer for fetching the call status API every 2 seconds
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (callStatusModel.callStatus != "call_ended")
        getNetworkStatus();
      else
        cancelTimer();
    });
  }

//Cancels the timer
  void cancelTimer() {
    _timer.cancel();
    update();
  }

//Fetches the network status i.e call_going, call_failed...
  void getNetworkStatus() async {
    setState(ViewState.Busy);
    callStatusModel = await apiAuthProvider.fetchNetworkStatus();
    if (callStatusModel != null) {
      firstLoad = false;
      locator<SharedPreferencesManager>()
          .putString("conferenceSid", callStatusModel.conferenceSId);

      if (callStatusModel.callStatus == "call_failed") {
        locator<SharedPreferencesManager>().isKeyExists("callfailed")
            ? locator<SharedPreferencesManager>().putInt("callfailed",
                locator<SharedPreferencesManager>().getInt("callfailed") + 1)
            : locator<SharedPreferencesManager>().putInt("callfailed", 1);
        print(
            "count: ${locator<SharedPreferencesManager>().getInt("callfailed")}");
        update();
      }
    }
    if (callStatusModel.isRetrying == true) {
      await locator<SharedPreferencesManager>().putBool('callGoing', true);
    }

    if (callStatusModel.callStatus == "call_ended" ||
        callStatusModel.callStatus == "call_terminated" ||
        (callStatusModel.callStatus == "call_failed" &&
            callStatusModel.isRetrying == false) ||
        callStatusModel.callStatus == null) {
      await locator<SharedPreferencesManager>().putBool('callGoing', false);
      await locator<SharedPreferencesManager>().clearKey('callTrackerImage');
    } else {
      await locator<SharedPreferencesManager>().putBool('callGoing', true);
    }
    setState(ViewState.Retrieved);
    update();
  }

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    super.onInit();
    from = Get.arguments["from"];
    fetchDidYouKnow();
    getNetworkStatus();
    startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<CallTrackerController>();
    _timer.cancel();
  }
}
