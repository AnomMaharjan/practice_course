import 'package:get/get.dart';

import '../controllers/new_terms_of_use_controller.dart';

class NewTermsOfUseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewTermsOfUseController>(
      () => NewTermsOfUseController(),
    );
  }
}
