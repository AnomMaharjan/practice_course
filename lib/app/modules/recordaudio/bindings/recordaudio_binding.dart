import 'package:get/get.dart';

import '../controllers/recordaudio_controller.dart';

class RecordaudioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordAudioController>(
      () => RecordAudioController(),
    );
  }
}
