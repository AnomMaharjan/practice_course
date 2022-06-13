import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';

class HomeController extends BaseController {
  RemoteConfig remoteConfig = RemoteConfig.instance;
  var policies = [].obs;
  Future<void> initConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(
          seconds: 30), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: Duration(
          seconds:
              60), // fetch parameters will be cached for a maximum of 1 hour
    ));

    fetchConfig();
  }

  void fetchConfig() async {
    setState(ViewState.Busy);
    await RemoteConfig.instance.fetchAndActivate();
    var rawData = remoteConfig.getAll()['privacy_policy'];
    var map = jsonDecode(rawData.asString() ?? []);
    policies.assignAll(map["policies"]);
    setState(ViewState.Retrieved);
  }

  @override
  void onInit() {
    initConfig();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

}
