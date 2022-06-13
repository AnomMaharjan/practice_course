import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:q4me/app/modules/call_ended/bindings/call_ended_binding.dart';
import 'package:q4me/app/modules/call_ended/views/call_ended_view.dart';
import 'package:q4me/app/modules/call_failed/bindings/call_failed_binding.dart';
import 'package:q4me/app/modules/call_failed/views/call_failed_view.dart';
import 'package:q4me/app/modules/call_tracker/bindings/call_tracker_binding.dart';
import 'package:q4me/app/modules/call_tracker/views/call_tracker_view.dart';
import 'package:q4me/app/modules/trial_page/bindings/trial_page_binding.dart';
import 'package:q4me/app/modules/trial_page/views/trial_page_view.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //checks if the app is used for the first time or not.
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Get.offAllNamed(Routes.LOGIN_PAGE);
    } else {
      prefs.setBool('seen', true);
      Get.offAllNamed(Routes.TOUR_SCREEN);
    }
  }

  //gets the FCM token of the device.
  getFCMToken() {
    _firebaseMessaging.getToken().then((value) {
      sharedPreferencesManager.putString(
          SharedPreferencesManager.keyFCMToken, value);
      print("Firebase token ${sharedPreferencesManager.getString("FCMToken")}");
    });
  }

  //handles notification
  void configureNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message != null) {
        print("notification type: ${message.data["notification_type"]}");
        print("conf id: ${message.data["conference_id"]}");
        if (message.data["call_failed_after_auto_retry"] == true) {
          sharedPreferencesManager.putBool("callGoing", false);
        }
        if (message.data["notification_type"] == "call_failed") {
          Get.to(
              CallFailedView(
                from: "opened",
              ),
              binding: CallFailedBinding());
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

  //function to ask contact permission.
  void askContactPermission() async {
    await Permission.contacts.request();
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      PermissionStatus permission = await Permission.contacts.status;
      if (permission == PermissionStatus.granted) {
        await locator<SharedPreferencesManager>()
            .putBool('permissionAllowed', true);
        print(
            "contact permission: ${locator<SharedPreferencesManager>().getBool(
          'permissionAllowed',
        )}");
      } else {
        await locator<SharedPreferencesManager>()
            .putBool('permissionAllowed', false);
        print(
            "contact permission: ${locator<SharedPreferencesManager>().getBool(
          'permissionAllowed',
        )}");
      }
    } else
      await locator<SharedPreferencesManager>()
          .putBool('permissionAllowed', true);
  }

  //checks the contact permission status.
  void checkContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission == PermissionStatus.granted) {
      await locator<SharedPreferencesManager>()
          .putBool('permissionAllowed', true);
    } else {
      await locator<SharedPreferencesManager>()
          .putBool('permissionAllowed', false);
    }
    print("permission: $permission");
    print(
        "permission status: ${locator<SharedPreferencesManager>().getBool('permissionAllowed')}");
  }

  @override
  void onInit() async {
    super.onInit();
    await getFCMToken();
    await !locator<SharedPreferencesManager>().isKeyExists('permissionAllowed')
        ? askContactPermission()
        : checkContactPermission();
    RemoteMessage initialMessage = await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data["call_failed_after_auto_retry"] == true) {
        sharedPreferencesManager.putBool("callGoing", false);
      }
      if (initialMessage.data["notification_type"] == "call_failed") {
        Get.to(
            CallFailedView(
              from: "opened",
            ),
            binding: CallFailedBinding());
      } else if (initialMessage.data["notification_type"] == "call_ended") {
        Get.to(
            () => CallEndedView(
                imageName: initialMessage.data["image_url"],
                minutesSaved: initialMessage.data["minutes_saved"]),
            arguments: {
              "conferenceId": initialMessage.data["conference_id"],
              "serviceProviderName":
                  initialMessage.data["service_provider_name"]
            },
            binding: CallEndedBinding());
      } else if (initialMessage.data["notification_type"] == "retrying") {
        Get.to(
            () => CallTrackerView(
                  imageName: initialMessage.data["image_url"],
                ),
            arguments: {"from": 1},
            binding: CallTrackerBinding());
      }
    } else {
      Timer(new Duration(seconds: 3), () {
        if (sharedPreferencesManager.getBool('isLogin') == true &&
            sharedPreferencesManager.getBool("isSubscribed") == true) {
          Get.offAllNamed(Routes.HOMEPAGE);
        } else if (sharedPreferencesManager.getBool('isLogin') == true &&
            sharedPreferencesManager.getBool("isSubscribed") == false) {
          Get.offAll(() => TrialPageView(), binding: TrialPageBinding());
        } else {
          checkFirstSeen();
        }
      });

      configureNotifications();
    }
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<SplashScreenController>();
  }
}
