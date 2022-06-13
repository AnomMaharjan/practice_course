import 'package:get/get.dart';

import '../controllers/service_page_controller.dart';

class ServicePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicePageController>(
      () => ServicePageController(),
    );
  }
}
