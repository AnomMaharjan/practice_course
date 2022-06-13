import 'package:get/get.dart';

import '../controllers/add_credit_page_controller.dart';

class AddCreditPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCreditPageController>(
      () => AddCreditPageController(),
    );
  }
}
