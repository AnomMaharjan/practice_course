import 'package:get/get.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';

class TourScreenController extends BaseController {
  var firsttext = ''.obs;
  var secondtext = ''.obs;
  var thirdtext = ''.obs;
  var firstImage = ''.obs;
  var secondImage = ''.obs;
  var thirdImage = ''.obs;
  RemoteConfig remoteConfig = RemoteConfig.instance;

  Future<void> initConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(
          seconds: 30), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: Duration(
          seconds:
              60), // fetch parameters will be cached for a maximum of 1 hour
    ));

    fetchConfig();

    print(
        'yo ho hai value: ${remoteConfig.getString('color_text').toString()}');
  }

  void fetchConfig() async {
    setState(ViewState.Busy);
    await remoteConfig.fetchAndActivate();
    firsttext.value =
        remoteConfig.getString('first_text').replaceAll("\\n", "\n");
    firstImage.value = remoteConfig.getString('first_image');
    secondtext.value =
        remoteConfig.getString('second_text').replaceAll("\\n", "\n");
    secondImage.value = remoteConfig.getString('second_image');
    thirdtext.value =
        remoteConfig.getString('third_text').replaceAll("\\n", "\n");
    thirdImage.value = remoteConfig.getString('third_image');
    setState(ViewState.Retrieved);
  }

  @override
  void onInit() {
    initConfig();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
