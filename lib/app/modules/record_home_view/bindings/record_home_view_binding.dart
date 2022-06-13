import 'package:get/get.dart';

import '../controllers/record_home_view_controller.dart';

class RecordHomeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordHomeViewController>(
      () => RecordHomeViewController(),
    );
  }
}
