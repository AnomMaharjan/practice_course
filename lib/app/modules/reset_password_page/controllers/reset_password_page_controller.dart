import 'package:flutter/material.dart';
import 'package:q4me/api/api_auth_provider.dart';
import 'package:q4me/base_model/base_model.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';

class ResetPasswordPageController extends BaseController with Connection {
  bool confirmPassword = false;
  final TextEditingController emailController = TextEditingController();
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider();

  BuildContext contexts;

  initialize(BuildContext context) {
    contexts = context;
  }

  void resetPassword() async {
    Map map = {"email": emailController.text.trim()};
    setState(ViewState.Busy);
    var response = await _apiAuthProvider.resetPassword(map);
    if (response == true) {
      confirmPassword = true;
      setState(ViewState.Retrieved);
      update();
    } else
      setState(ViewState.Retrieved);

    update();
  }

  @override
  void onInit(){
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(contexts);
    });
  }
}
