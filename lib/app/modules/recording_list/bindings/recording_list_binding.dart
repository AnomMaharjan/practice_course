import 'package:get/get.dart';

import '../controllers/recording_list_controller.dart';

class RecordingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordingPlaybackController>(
      () => RecordingPlaybackController(),
    );
  }
}
