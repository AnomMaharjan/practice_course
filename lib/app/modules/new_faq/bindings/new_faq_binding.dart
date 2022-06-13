import 'package:get/get.dart';

import '../controllers/new_faq_controller.dart';

class NewFaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewFaqController>(
      () => NewFaqController(),
    );
  }
}
