import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveChatPageController extends GetxController with Connection{

 BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    super.onInit();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

}
