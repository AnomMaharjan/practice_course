import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/app/modules/call_tracker/bindings/call_tracker_binding.dart';
import 'package:q4me/app/modules/call_tracker/views/call_tracker_view.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/call_start.dart';
import 'package:q4me/model/ivr_mapping_model.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'dart:developer' as logger;

class ServicePageController extends BaseController with Connection {
  ApiAuthProvider apiAuthProvider = ApiAuthProvider();
  CallStart callStart;
  var loading = false.obs;
  var pressed = false.obs;
  PageModel page;
  var busy = false.obs;
  var connecting = false.obs;
  int nextPageId;
  List<int> pageList = [];
  RxBool showDynamicPage = false.obs;
  String dynamicPageTitle = "";
  List<TextEditingController> textEditingControllers =
      []; //list to store dynamically generated text editing controller
  List<String> dynamicInputSlugs =
      []; //list to store input slugs retrieved from API
  List<int> dynamicInputId = [];
  RxBool showTextField = false.obs;
  final formKey = GlobalKey<FormState>();

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
    locator<SharedPreferencesManager>().putBool("isLoading", false);
    nextPageId = Get.arguments["nextPageId"];
    fetchPage();
  }

  void fetchPage({int pageId, int from}) async {
    busy.value = true;
    if (from == null) {
      page = await apiAuthProvider.fetchPage(id: nextPageId);
      if (page != null) if (page.dynamicInputStatus) {
        if (page.dynamicInput.fieldType == "text" ||
            page.dynamicInput.fieldType == "txt") {
          showTextField.value = true;
          update();
        } else {
          showTextField.value = false;
          update();
        }
        showDynamicPage.value = true;

        textEditingControllers.add(TextEditingController(
            text: page.inputText == null ? "" : page.inputText));
        dynamicInputSlugs.add(page.dynamicInput.fieldSlug);
        dynamicInputId.add(page.dynamicInput.id);
        update();
      }
    } else {
      page = await apiAuthProvider.fetchPage(id: pageId);
      if (page.dynamicInputStatus != null) {
        if (page.dynamicInputStatus) {
          if (page.dynamicInput.fieldType == "text" ||
              page.dynamicInput.fieldType == "txt") {
            showTextField.value = true;
            update();
          } else {
            showTextField.value = false;
            update();
          }
          showDynamicPage.value = true;

          textEditingControllers.add(TextEditingController(
              text: page.inputText == null ? "" : page.inputText));
          dynamicInputSlugs.add(page.dynamicInput.fieldSlug);
          dynamicInputId.add(page.dynamicInput.id);
          update();
        }
      }
    }
    showDynamicPage.value = false;
    from = null;
    busy.value = false;
    update();
  }

  void previousPage() async {
    busy.value = true;
    print("status::: ${showDynamicPage.value}");
    page = await apiAuthProvider.fetchPage(id: pageList.last);
    page.dynamicInputStatus ? showDynamicPage.value = true : false;
    if (page.dynamicInputStatus) {
      if (page.dynamicInput.fieldType == "text" ||
          page.dynamicInput.fieldType == "txt") {
        showTextField.value = true;
        update();
      } else {
        showTextField.value = false;
        update();
      }
    }
    update();

    pageList.removeLast();
    busy.value = false;
    update();
  }

  void performCall({int componentId, String imageName}) async {
    String dynamicInputQueryParameters = "";

    for (int i = 0; i < textEditingControllers.length; i++) {
      var map = jsonEncode({
        "id": dynamicInputId[i],
        "value": "${textEditingControllers[i].text.trim()}"
      });
      dynamicInputQueryParameters =
          dynamicInputQueryParameters + '&${dynamicInputSlugs[i]}=$map';
      update();
    }
    print(dynamicInputQueryParameters);
    setState(ViewState.Busy);

    locator<SharedPreferencesManager>().putBool("isLoading", true);
    connecting.value = true;
    logger.log("component id $componentId");
    bool calling = await apiAuthProvider.performCall(
        componentId, dynamicInputQueryParameters);

    if (calling == true) {
      locator<SharedPreferencesManager>().putBool("callGoing", true);

      onCallSuccess(imageName: imageName);
    } else {
      locator<SharedPreferencesManager>().putBool("isLoading", false);
      connecting.value = false;
      setState(ViewState.Retrieved);
      locator<SharedPreferencesManager>().putBool("isLoading", false);
      // Get.snackbar('Error!', 'Could not make your call!',
      //     snackPosition: SnackPosition.TOP, backgroundColor: Color(0xfff2f2f2));
    }
  }

  void onCallSuccess({String imageName}) async {
    locator<SharedPreferencesManager>().putBool("isLoading", false);
    locator<SharedPreferencesManager>().putInt("callfailed", 0);

    connecting.value = false;
    Get.to(() => CallTrackerView(imageName: imageName),
        arguments: {"from": 0},
        transition: Transition.fade,
        binding: CallTrackerBinding());
    setState(ViewState.Retrieved);
  }
}
