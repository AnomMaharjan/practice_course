import 'package:q4me/constants/enum.dart';
import 'package:get/state_manager.dart';

class BaseController extends GetxController {
  var _state = ViewState.Idle.obs;

  ViewState get state => _state.value;

  void setState(ViewState newState){
    _state.value = newState;
  }
}