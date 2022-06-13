import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/model/faq.dart';

import '../../../../api/new_apis.dart';
import '../../../../base_model/base_model.dart';

class NewFaqController extends BaseController with Connection {
  List faqDataList = [];
  List<Faq> faq;
  final NewApi _newApi = NewApi();

  void getFaqData() async {
    setState(ViewState.Busy);
    faq = await _newApi.fetchFaqData();
    print('======faq data === \n$faq');
    if (faq == null) setState(ViewState.Retrieved);
    setState(ViewState.Retrieved);
    update();
  }

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  @override
  void onInit() {
    getFaqData();
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
