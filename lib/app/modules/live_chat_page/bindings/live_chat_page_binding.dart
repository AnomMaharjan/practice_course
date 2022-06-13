import 'package:get/get.dart';

import '../controllers/live_chat_page_controller.dart';

class LiveChatPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveChatPageController>(
      () => LiveChatPageController(),
    );
  }
}
