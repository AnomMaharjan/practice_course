import 'package:get/get.dart';
import 'package:q4me/api/new_apis.dart';
import 'package:q4me/base_model/base_model.dart';

import '../../../../constants/enum.dart';
import '../../../../model/privacy_policy_model.dart';

class NewTermsOfUseController extends BaseController {
  List<PrivacyPolicy> termsoOfUse;
  final NewApi _newApi = NewApi();
  bool morePressed = false;

  void getPrivacyPolicyData() async {
    setState(ViewState.Busy);
    termsoOfUse = await _newApi.fetchTermsOfUseData();
    print('======termsoOfUse data === \n$termsoOfUse');
    if (termsoOfUse == null) setState(ViewState.Retrieved);
    setState(ViewState.Retrieved);
    update();
  }

  void morePress() {
    morePressed = !morePressed;
    update();
  }

  @override
  void onInit() {
    getPrivacyPolicyData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
