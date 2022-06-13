import 'package:get/get.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/model/privacy_policy_model.dart';

class PrivacyPolicyPageController extends BaseController {
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider();
  List<PrivacyPolicy> privacyPolicy = [];

  void fetchPrivacyPolicy() async {
    setState(ViewState.Busy);
    privacyPolicy = await _apiAuthProvider.getPrivacyPolicy();
    if (privacyPolicy == null) {
      Get.snackbar("Privacy Policy Error", "Could not fetch privacy policy.");
    }
    print("privacy policy: $privacyPolicy");
    setState(ViewState.Retrieved);
  }

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }
}
