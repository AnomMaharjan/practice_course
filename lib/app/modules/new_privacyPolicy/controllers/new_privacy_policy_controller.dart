import 'package:get/get.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/model/privacy_policy_model.dart';

import '../../../../api/new_apis.dart';

class NewPrivacyPolicyController extends BaseController {
  List<PrivacyPolicy> privacyPolicyData;
  final NewApi _newApi = NewApi();
  bool morePressed = false;
  

  void getPrivacyPolicyData() async {
    setState(ViewState.Busy);
    privacyPolicyData = await _newApi.fetchPrivacyPolicyData();
    print('======privacyPolicyData data === \n$privacyPolicyData');
    if (privacyPolicyData == null) setState(ViewState.Retrieved);
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
