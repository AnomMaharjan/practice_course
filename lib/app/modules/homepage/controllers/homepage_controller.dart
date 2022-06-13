import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/online_status_model.dart';
import 'package:q4me/model/retrieve_dashboard_component_model.dart';
import 'package:q4me/service/connectivit_service.dart';
import 'package:q4me/service/user_stats_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';

class HomepageController extends BaseController with Connection {
  var pressed = true;
  final UserStatService userStatService = locator<UserStatService>();
  final Connectivity _connectivity = Connectivity();
  ApiAuthProvider apiAuthProvider = ApiAuthProvider();
  List<RetrieveDashboardComponent> retrievedComponents = [];
  Iterable<Contact> allContacts;
  var phones = [].obs;
  ScrollController scrollController;
  final TextEditingController searchController = TextEditingController();
  List<RetrieveDashboardComponent> filteredList;
  String searchText = "";
  BuildContext contexts;
  Size size;
  String dropdownValue = "Popular";
  final TextEditingController controller = TextEditingController();
  Timer _timer;
  Timer _timer1;
  Timer _timer2;
  List<OnlineStatus> onlineStatusList = [];

  final ConnectivityService connectivityService =
      locator<ConnectivityService>();

  fetchComponents() async {
    retrievedComponents = await apiAuthProvider.getRetrieveDashboardComponent();
    filteredList = retrievedComponents;
    update();
  }

  getOnlineStatus() async {
    onlineStatusList = await apiAuthProvider.getOnlineStatus();
    try {
      if (onlineStatusList.length != retrievedComponents.length) {
        onRefresh();
      } else {
        for (int i = 0; i < onlineStatusList.length; i++) {
          if (retrievedComponents[i].status != onlineStatusList[i].status ||
              retrievedComponents[i].id != onlineStatusList[i].id) {
            onRefresh();
          }
        }
      }
      update();
    } catch (error) {
      return null;
    }
  }

  // getOnlineStatus() async {
  //   onlineStatusList = await apiAuthProvider.getOnlineStatus();
  //   if (onlineStatusList != null) {
  //     if (onlineStatusList.length != retrievedComponents.length) {
  //       onRefresh();
  //     } else {
  //       for (int i = 0; i < onlineStatusList.length; i++) {
  //         if (retrievedComponents[i].status != onlineStatusList[i].status ||
  //             retrievedComponents[i].id != onlineStatusList[i].id) {
  //           onRefresh();
  //         }
  //       }
  //     }
  //     update();
  //   } else {
  //     null;
  //   }
  // }

  refreshCache() async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      apiAuthProvider.clearCache();
    } else {
      null;
    }
    update();
  }

  Future<void> getContacts() async {
    setState(ViewState.Busy);
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    contacts.forEach((contact) {
      contact.phones.toSet().forEach((phone) {
        phones.add(phone.value);
      });
    });
    print('contactssss ${phones}');
  }

  Future<void> saveContactInPhone(String username, String phoneNumber) async {
    PermissionStatus permission = await Permission.contacts.status;
    try {
      if (permission != PermissionStatus.granted) {
        final status = await Permission.contacts.request();
        print("status::: $status");
        PermissionStatus permission = await Permission.contacts.status;
        if (permission == PermissionStatus.granted) {
          await locator<SharedPreferencesManager>()
              .putBool('permissionAllowed', true);
          addContacts(username, phoneNumber);
        }
      } else {
        addContacts(username, phoneNumber);
      }
    } catch (e) {
      print(e);
    }
  }

  void addContacts(String username, String phoneNumber) async {
    Contact newContact = new Contact();
    newContact.givenName = username;
    newContact.familyName = "";
    newContact.phones = [Item(label: "mobile", value: phoneNumber)];
    phones.add(phoneNumber);
    await ContactsService.addContact(newContact);
  }

  getHomepageData() {
    getUserStatus();
    fetchAllComponents();
  }

  getUserStatus() async {
    await userStatService.fetchUserStatus();
    update();
  }

  getSubscriptionStatus() async {
    await userStatService.fetchSubscriptionStatus();
    update();
  }

  fetchAllComponents() async {
    setState(ViewState.Busy);
    await fetchComponents();
    await locator<SharedPreferencesManager>().getBool("permissionAllowed")
        ? getContacts()
        : null;
    setState(ViewState.Retrieved);
    update();
  }

  initialize(BuildContext context) {
    contexts = context;
    size = MediaQuery.of(contexts).size;
  }

  changeDropdownValue(value) {
    dropdownValue = value;
    update();
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (_timer) {
      getUserStatus();
    });
  }

  startSubscriptionStatusTimer() {
    _timer1 = Timer.periodic(Duration(minutes: 1), (_timer1) {
      getSubscriptionStatus();
    });
  }

  startOnlineStatusTimer() {
    _timer2 = Timer.periodic(Duration(seconds: 20), (_timer1) {
      getOnlineStatus();
    });
  }

  onRefresh() {
    refreshCache();
    fetchComponents();
  }

  void searchComponent(String text) {
    if (!text.isEmpty) {
      List<RetrieveDashboardComponent> tempList = [];
      for (int i = 0; i < retrievedComponents.length; i++) {
        if (retrievedComponents[i]
            .title
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          tempList.add(retrievedComponents[i]);
        }
      }
      filteredList = tempList;
      update();
    } else {
      filteredList = retrievedComponents;
      update();
    }
  }

  cancelTimer() {
    _timer.cancel();
  }

  //dropdown for category/sort by
  // String itemValue = "Last Used";
  // List items = ["Last Used", "Popular", "Newest Added"];

  // dialogue(context) {
  //   return showDialog<void>(
  //     barrierDismissible: true,
  //     barrierColor: Colors.transparent,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SimpleDialog
  //         titlePadding: EdgeInsets.zero,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(6),
  //         ),
  //         contentPadding: EdgeInsets.zero,
  //         insetPadding: size.height >= 926
  //             ? EdgeInsets.only(left: 180, right: 30, bottom: 150)
  //             : size.height <= 667
  //                 ? EdgeInsets.only(left: 180, right: 30, bottom: 150, top: 160)
  //                 : size.height >= 896
  //                     ? EdgeInsets.only(
  //                         left: 180, right: 30, bottom: 150, top: 20)
  //                     : size.height > 822 && size.height < 896
  //                         ? EdgeInsets.only(
  //                             left: 180, right: 30, bottom: 150, top: 0)
  //                         : EdgeInsets.only(
  //                             left: 180, right: 30, bottom: 150, top: 80),
  //         children: [
  //           Column(
  //             children: List.generate(
  //               items.length,
  //               (index) {
  //                 return ListTile(
  //                   title: items[index] == itemValue
  //                       ? Text(
  //                           items[index],
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               color: GLOBAL_THEME_COLOR),
  //                         )
  //                       : Text(items[index],
  //                           style: TextStyle(color: GLOBAL_THEME_COLOR)),
  //                   onTap: () {
  //                     itemValue = items[index];
  //                     Navigator.pop(context);
  //                     update();
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void onInit() async {
    super.onInit();
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.getToken().then((value) {
      locator<SharedPreferencesManager>()
          .putString(SharedPreferencesManager.keyFCMToken, value);
    });
    startTimer();
    getHomepageData();
    startSubscriptionStatusTimer();
    startOnlineStatusTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
    _timer1.cancel();
    _timer2.cancel();
  }
}
