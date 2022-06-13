import 'package:get/get.dart';

import '../controllers/configuration_page_controller.dart';

class ConfigurationPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfigurationPageController>(
      () => ConfigurationPageController(),
    );
  }
}
