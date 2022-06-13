import 'package:flutter/material.dart';
import 'package:q4me/api/new_apis.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/profile.dart';
import 'package:q4me/service/analytics_service.dart';

class ProfilePageController extends BaseController with Connection {
  final NewApi _newApi = NewApi();
  Profile profileData;
  List profile = [];
  BuildContext contexts;
  final AnalyticsService analyticsService = locator<AnalyticsService>();

  initialize(BuildContext context) {
    contexts = context;
  }

  void getProfileInfo() async {
    setState(ViewState.Busy);
    profileData = await _newApi.fetchProfileInfo();
    setState(ViewState.Retrieved);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getProfileInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }

  void onClose() {
    super.onClose();
  }
}
