import 'package:get/get.dart';

import '../controllers/call_failed_controller.dart';

class CallFailedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallFailedController>(
      () => CallFailedController(),
    );
  }
}
