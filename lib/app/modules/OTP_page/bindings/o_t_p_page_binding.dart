import 'package:get/get.dart';

import '../controllers/o_t_p_page_controller.dart';

class OTPPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OTPPageController>(
      () => OTPPageController(),
    );
  }
}
