import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';

class ConfigurationPageController extends GetxController
    with WidgetsBindingObserver, Connection {
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider();
  RxBool autoRetryStatus;
  final Connectivity _connectivity = Connectivity();
  RxBool loading = false.obs;
  RxBool notificationStatus = false.obs;
  RxDouble opacity = 1.0.obs;

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  enableRetry() async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      autoRetryStatus.value = !autoRetryStatus.value;
      bool response = await _apiAuthProvider.enableAutoRetryFeature();
      if (response != true) {
        locator<SharedPreferencesManager>().getBool("autoretry")
            ? Fluttertoast.showToast(
                msg: "Could not disable the auto retry feature",
                gravity: ToastGravity.TOP,
                backgroundColor: GLOBAL_GREEN_COLOR,
                textColor: Colors.white)
            : Fluttertoast.showToast(
                msg: "Could not enable the auto retry feature",
                gravity: ToastGravity.TOP,
                backgroundColor: GLOBAL_GREEN_COLOR,
                textColor: Colors.white);
        autoRetryStatus.value =
            !locator<SharedPreferencesManager>().getBool("autoretry");
        update();
      } else {
        locator<SharedPreferencesManager>().putBool("autoretry",
            !locator<SharedPreferencesManager>().getBool("autoretry"));
      }
    } else {
      Fluttertoast.showToast(msg: "Device Not Connected to the Internet.");
    }
  }

  checkNotificationPermission() async {
    var permissionStatus = await Permission.notification.status;
    print("${permissionStatus}");
    if (await Permission.notification.request().isGranted ||
        permissionStatus == PermissionStatus.granted) {
      print("trueeee");
      print("permission: ${permissionStatus}");
      notificationStatus.value = true;
    } else {
      print("falseeeeee");
      print("permission: ${permissionStatus}");
      notificationStatus.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
    checkNotificationPermission();
    autoRetryStatus =
        locator<SharedPreferencesManager>().getBool("autoretry").obs;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.resumed) {
      checkNotificationPermission();
    }
  }
}
