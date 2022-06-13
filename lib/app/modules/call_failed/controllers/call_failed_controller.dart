import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/modules/call_tracker/views/call_tracker_view.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/call_status_model.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';

class CallFailedController extends GetxController with Connection {
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider();
  var loading = false.obs;
  var retrying = false.obs;

  CallStatusModel callStatusModel;

  getNetworkStatus() async {
    loading.value = true;
    callStatusModel = await _apiAuthProvider.fetchNetworkStatus();
    if (callStatusModel != null) {
      loading.value = false;
      locator<SharedPreferencesManager>()
          .putString("conferenceSid", callStatusModel.conferenceSId);
    } else
      loading.value = false;
  }

  retryCall() async {
    retrying.value = true;
    bool response = await _apiAuthProvider.retryCall(
        conferenceSid:
            locator<SharedPreferencesManager>().getString("conferenceSid"));
    print("response:::: $response");
    if (response == true) {
      locator<SharedPreferencesManager>().putInt("callfailed", 0);
      retrying.value = false;
      Get.off(() => CallTrackerView(imageName: callStatusModel.imageUrl),
          arguments: {"from": 0});
    }

    retrying.value = false;
  }

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    super.onInit();
    getNetworkStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }
}
