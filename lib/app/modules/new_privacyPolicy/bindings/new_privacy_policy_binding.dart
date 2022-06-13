import 'package:get/get.dart';

import '../controllers/new_privacy_policy_controller.dart';

class NewPrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewPrivacyPolicyController>(
      () => NewPrivacyPolicyController(),
    );
  }
}
