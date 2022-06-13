import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:q4me/api/new_apis.dart';
import 'package:q4me/app/modules/homepage/bindings/homepage_binding.dart';
import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/address_finder.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/globals/globals.dart' as globals;

import '../../../../base_model/base_model.dart';

class ProfileInformationPageController extends BaseController with Connection {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressFinderController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController postCode = TextEditingController();

  final formKey = GlobalKey<FormState>();

  RxBool addressFinderPressed = false.obs;
  RxBool continueBtnColorStatus = false.obs;
  RxBool addressManuallyPressed = false.obs;
  RxBool addressManuallyPressedErrorPopUp = false.obs;

  final NewApi _newApi = NewApi();
  AddressFinder addressFinder;
  List addressList = [];

  List addressFinderList = [].obs;
  RxBool buttonActivated = false.obs;

  BuildContext contexts;

  final AnalyticsService analyticsService = locator<AnalyticsService>();

  initialize(BuildContext context) {
    contexts = context;
  }

  bool changeContinueBtnColor() {
    if (firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        addressFinderController.text.isNotEmpty ||
        addressLine1Controller.text.isNotEmpty ||
        addressLine2Controller.text.isNotEmpty ||
        postCode.text.isNotEmpty) {
      buttonActivated.value = true;
      update();
      return continueBtnColorStatus.value = true;
    } else if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        addressLine1Controller.text.isNotEmpty &&
        addressLine2Controller.text.isNotEmpty &&
        postCode.text.isNotEmpty) {
      buttonActivated.value = true;
      update();
      return continueBtnColorStatus.value = true;
    } else
      return continueBtnColorStatus.value = false;
  }

  void getAddress({String postCode}) async {
    setState(ViewState.Busy);
    addressFinder = await _newApi.fetchAddressFinder(postCode: postCode);
    if (addressFinder != null)
      addressFinderList.assignAll(addressFinder.results);
    print(addressFinderList[0].id);
    setState(ViewState.Retrieved);
  }

  void postAddress() async {
    print("postaddress");
    Map body = {
      "first_name": firstNameController.text.isEmpty
          ? ""
          : firstNameController.text.trim(),
      "last_name":
          lastNameController.text.isEmpty ? "" : lastNameController.text.trim(),
      "address_1": '',
      "postal_code": addressFinderController.text.isEmpty
          ? ""
          : addressFinderController.text.trim(),
      "address_2": "",
    };
    await _newApi.postAddresss(body: body);
    setState(ViewState.Busy);
    await _newApi.clearCache(endpoint: '/api/user/information/retrieve/');
    Fluttertoast.showToast(
        msg: "Successfully updated", gravity: ToastGravity.TOP);
    locator<SharedPreferencesManager>().putBool("userInfoUpdated", true);
    globals.currentIndex.value = 0;
    globals.topupStatus.value = false;
    globals.addCreditStatus.value = false;
    Get.offAll(() => HomepageView(), binding: HomepageBinding());
    addressFinderController.clear();
    addressFinderController.clearComposing();
    continueBtnColorStatus.value = false;
    setState(ViewState.Retrieved);
  }

  void postAdressManualy() async {
    print("postaddress manual");
    Map body = {
      "first_name": firstNameController.text.isEmpty
          ? ""
          : firstNameController.text.trim(),
      "last_name":
          lastNameController.text.isEmpty ? "" : lastNameController.text.trim(),
      "address_1": addressLine1Controller.text.isEmpty
          ? ""
          : addressLine1Controller.text.trim(),
      "address_2": addressLine2Controller.text.isEmpty
          ? ""
          : addressLine2Controller.text.trim(),
      "postal_code": postCode.text.isEmpty ? "" : postCode.text.trim(),
    };
    setState(ViewState.Busy);
    await _newApi.postAddresss(body: body);
    await _newApi.clearCache(endpoint: '/api/user/information/retrieve/');
    Fluttertoast.showToast(
        msg: "Successfully updated", gravity: ToastGravity.TOP);
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    postCode.clear();
    continueBtnColorStatus.value = false;
    locator<SharedPreferencesManager>().putBool("userInfoUpdated", true);
    globals.currentIndex.value = 0;
    globals.topupStatus.value = false;
    globals.addCreditStatus.value = false;
    Get.offAll(() => HomepageView(), binding: HomepageBinding());
    setState(ViewState.Retrieved);
  }

  @override
  void onInit() {
    super.onInit();
    getAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }

  void onClose() {
    firstNameController.clear();
    lastNameController.clear();
    addressFinderController.clear();
    super.onClose();
  }
}
