import 'package:get/get.dart';

import '../controllers/call_tracker_controller.dart';

class CallTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallTrackerController>(
      () => CallTrackerController(),
    );
  }
}
