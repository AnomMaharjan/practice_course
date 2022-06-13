import 'package:get/get.dart';

import '../controllers/frequently_asked_questions_controller.dart';

class FrequentlyAskedQuestionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FrequentlyAskedQuestionsController>(
      () => FrequentlyAskedQuestionsController(),
    );
  }
}
