import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:q4me/app/modules/call_failed/bindings/call_failed_binding.dart';
import 'package:q4me/app/modules/call_tracker/bindings/call_tracker_binding.dart';
import 'package:q4me/app/modules/call_tracker/views/call_tracker_view.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'package:q4me/utils/global_key.dart';
import 'app/modules/call_ended/bindings/call_ended_binding.dart';
import 'app/modules/call_ended/views/call_ended_view.dart';
import 'app/modules/call_failed/views/call_failed_view.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';

SharedPreferencesManager sharedPreferencesManager =
    locator<SharedPreferencesManager>();
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message != null) {
    if (message.data["notification_type"] == "call_failed") {
      Get.to(
          CallFailedView(
            from: "opened",
          ),
          binding: CallFailedBinding());
      // message.data.clear();
    } else if (message.data["notification_type"] == "call_ended") {
      Get.to(
          () => CallEndedView(
              imageName: message.data["image_url"],
              minutesSaved: message.data["minutes_saved"]),
          arguments: {
            "conferenceId": message.data["conference_id"],
            "serviceProviderName": message.data["service_provider_name"]
          },
          binding: CallEndedBinding());
      // message.data.clear();
    } else if (message.data["notification_type"] == "retrying") {
      Get.to(
          () => CallTrackerView(
                imageName: message.data["image_url"],
              ),
          arguments: {"from": 1},
          binding: CallTrackerBinding());
    }
  }
}

void configureNotifications() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message != null) {
      print("notification type: ${message.data["notification_type"]}");
      if (message.data["notification_type"] == "call_failed") {
        Get.to(
            CallFailedView(
              from: "opened",
            ),
            binding: CallFailedBinding());
        // message.data.clear();
      } else if (message.data["notification_type"] == "call_ended") {
        Get.to(
            () => CallEndedView(
                imageName: message.data["image_url"],
                minutesSaved: message.data["minutes_saved"]),
            arguments: {
              "conferenceId": message.data["conference_id"],
              "serviceProviderName": message.data["service_provider_name"]
            },
            binding: CallEndedBinding());
        // message.data.clear();
      } else if (message.data["notification_type"] == "retrying") {
        Get.to(
            () => CallTrackerView(
                  imageName: message.data["image_url"],
                ),
            arguments: {"from": 1},
            binding: CallTrackerBinding());
      }
      if (message.data["call_failed_after_auto_retry"] == true) {
        sharedPreferencesManager.putBool("callGoing", false);
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message != null) {
      print("notification type: ${message.data}");

      if (message.data["call_failed_after_auto_retry"] == true) {
        sharedPreferencesManager.putBool("callGoing", false);
      }
      if (message.data["notification_type"] == "call_failed") {
        Get.to(
            CallFailedView(
              from: "opened",
            ),
            binding: CallFailedBinding());
        // message.data.clear();
      } else if (message.data["notification_type"] == "call_ended") {
        Get.to(
            () => CallEndedView(
                imageName: message.data["image_url"],
                minutesSaved: message.data["minutes_saved"]),
            arguments: {
              "conferenceId": message.data["conference_id"],
              "serviceProviderName": message.data["service_provider_name"]
            },
            binding: CallEndedBinding());
        // message.data.clear();
      } else if (message.data["notification_type"] == "retrying") {
        Get.to(
            () => CallTrackerView(
                  imageName: message.data["image_url"],
                ),
            arguments: {"from": 1},
            binding: CallTrackerBinding());
      }
    }
  });

  _firebaseMessaging.requestPermission(
    alert: true,
    sound: true,
    badge: true,
  );
}

getFCMToken() {
  _firebaseMessaging.getToken().then((value) {
    sharedPreferencesManager.putString(
        SharedPreferencesManager.keyFCMToken, value);
    print("Firebase token ${sharedPreferencesManager.getString("FCMToken")}");
  });
}

void main() async {
  const String flavor = String.fromEnvironment('app.flavor');
  if (Platform.isAndroid) {
    switch (flavor) {
      case "stage":
        Config.appFlavor = Flavor.STAGE;
        break;

      case "dev":
        Config.appFlavor = Flavor.DEVELOPMENT;
        break;

      default:
        Config.appFlavor = Flavor.PRODUCTION;
    }
  } else {
    Config.appFlavor = Flavor.PRODUCTION;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();
  await getFCMToken();
  configureNotifications();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setEnabledSystemUIOverlays(
    [],
  );

  runApp(
    OverlaySupport.global(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Q4ME",
        navigatorObservers: [
          locator<AnalyticsService>().getAnalyticsObserver()
        ],
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
      ),
    ),
  );
}
