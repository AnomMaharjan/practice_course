import 'package:get/get.dart';

import '../controllers/time_breakdown_controller.dart';

class TimeBreakdownBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeBreakdownController>(
      () => TimeBreakdownController(),
    );
  }
}
