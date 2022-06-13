import 'package:get/get.dart';

import '../controllers/tour_screen_controller.dart';

class TourScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TourScreenController>(
      () => TourScreenController(),
    );
  }
}
