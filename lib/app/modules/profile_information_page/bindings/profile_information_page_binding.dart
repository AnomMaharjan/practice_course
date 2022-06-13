import 'package:get/get.dart';

import '../controllers/profile_information_page_controller.dart';

class ProfileInformationPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileInformationPageController>(
      () => ProfileInformationPageController(),
    );
  }
}
