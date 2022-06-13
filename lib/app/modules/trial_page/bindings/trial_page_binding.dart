import 'package:get/get.dart';

import '../controllers/trial_page_controller.dart';

class TrialPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrialPageController>(
      () => TrialPageController(),
    );
  }
}
