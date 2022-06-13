import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';

class FrequentlyAskedQuestionsController extends BaseController
    with Connection {
  RemoteConfig remoteConfig = RemoteConfig.instance;
  var faqs = [].obs;

  Future<void> initConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(
          seconds: 10), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: Duration(
          seconds:
              10), // fetch parameters will be cached for a maximum of 1 hour
    ));
    fetchConfig();
  }

  void fetchConfig() async {
    setState(ViewState.Busy);
    await remoteConfig.fetchAndActivate();
    var rawData = remoteConfig.getAll()['FAQs'];
    var map = jsonDecode(rawData.asString() ?? []);
    faqs.assignAll(map["faqs"]);
    setState(ViewState.Retrieved);
  }

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    initConfig();
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
