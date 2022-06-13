import 'package:get/get.dart';

import '../controllers/call_ended_controller.dart';

class CallEndedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallEndedController>(
      () => CallEndedController(),
    );
  }
}
