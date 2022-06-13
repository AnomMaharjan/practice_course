import 'package:get/get.dart';

import '../controllers/privacy_policy_page_controller.dart';

class PrivacyPolicyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyPageController>(
      () => PrivacyPolicyPageController(),
    );
  }
}
