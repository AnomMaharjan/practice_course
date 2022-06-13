import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:q4me/api/new_apis.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/service/user_stats_service.dart';
import 'package:q4me/utils/string.dart';

class CallEndedController extends GetxController with Connection {
  // ConfettiController controllerCenter;
  final UserStatService _userStatService = locator<UserStatService>();
  var pressedNum = 0.obs;
  BuildContext context;
  final TextEditingController _descriptionTextController =
      TextEditingController();
  String conferenceId;
  String serviceProviderName;
  final NewApi _newApi = NewApi();
  final AnalyticsService analyticsService = locator<AnalyticsService>();

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initConnectivity(context);
      serviceProviderName = Get.arguments["serviceProviderName"];
      conferenceId = Get.arguments["conferenceId"];
    });
    fetchUserStat();
    Future.delayed(Duration(seconds: 3), () => dialogue());
  }

  cont(contexts) {
    context = contexts;
    update();
  }

  changeBtnColor(int index) {
    pressedNum.value = index;
    print('pressed Num == \n$pressedNum');
    update();
  }

  postReview() async {
    Map body = {
      "conference": conferenceId,
      "rating": pressedNum.value,
      "input_field": _descriptionTextController.text.trim()
    };
    var response = await _newApi.postNpsRating(body: body);

    if (response == true) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Review submitted successfully.",
          gravity: ToastGravity.TOP,
          backgroundColor: GLOBAL_GREEN_COLOR);
    }
  }

  dialogue() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          contentPadding:
              const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
          backgroundColor: Color(0xfff2f2f2),
          title: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                constraints: BoxConstraints(),
                padding: const EdgeInsets.only(bottom: 21),
                onPressed: () => Navigator.of(context).pop(),
                icon: SvgPicture.asset('assets/svgs/cross1.svg')),
          ),
          content: Builder(builder: (context) {
            return Container(
              width: Get.width,
              child: const Text(
                '''Would you\nlike to rate the call?''',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GLOBAL_THEME_COLOR),
              ),
            );
          }),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 51.0, top: 31),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Expanded(child: SizedBox(width: 5)),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      analyticsService.logEvent(
                          "canceled_review", "review canceled");
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(
                          fontSize: 16,
                          color: GLOBAL_GREEN_COLOR,
                          fontWeight: FontWeight.w600),
                    ),
                    minWidth: 128,
                    height: 44,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      dialogue1();
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    minWidth: 128,
                    height: 44,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    color: GLOBAL_GREEN_COLOR,
                  ),
                  const Expanded(child: SizedBox(width: 5)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  dialogue1() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xfff2f2f2),
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          contentPadding:
              const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
          title: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
                icon: SvgPicture.asset('assets/svgs/cross1.svg')),
          ),
          content: Builder(builder: (context) {
            return Container(
              width: Get.width,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    '''Based on your latest call''',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 22),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'How likely are you\n',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: SUB_HEADING_THEME_COLOR),
                        ),
                        TextSpan(
                          text: 'to recommend ',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: SUB_HEADING_THEME_COLOR),
                        ),
                        TextSpan(
                          text: '$serviceProviderName ',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: SUB_HEADING_THEME_COLOR,
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: 'to\n a friend or coworker?',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: SUB_HEADING_THEME_COLOR),
                        ),
                      ])),
                  const SizedBox(height: 28),
                  Container(
                    height: 3,
                    width: 20,
                    margin: EdgeInsets.symmetric(horizontal: 125),
                    decoration: BoxDecoration(
                      color: GLOBAL_GREEN_COLOR,
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  const SizedBox(height: 27),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                      child: Text(
                        'Not at all likely',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 5,
                        runSpacing: 14,
                        children: List.generate(
                          11,
                          (index) => GestureDetector(
                            onTap: () => Future.delayed(
                                Duration.zero, () => changeBtnColor(index)),
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: pressedNum.value == index
                                    ? Color(0xffb99fe1)
                                    : Colors.white,
                              ),
                              child: Center(
                                  child: Text(
                                '$index',
                                style: TextStyle(
                                    color: pressedNum.value == index
                                        ? Colors.white
                                        : GLOBAL_GREEN_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 5),
                      child: Text(
                        'Extremely likely',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 31),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                    ),
                    child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(children: [
                          TextSpan(
                            text: 'Can you share \n',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: 'any specific feedback about your score?',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.black),
                          ),
                        ])),
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(top: 13, left: 20, right: 20),
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 2, bottom: 10),
                    child: TextFormField(
                      controller: _descriptionTextController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: 'Leave your feedback here',
                          hintStyle: TextStyle(
                              color: Color(0xff212322).withOpacity(0.5),
                              fontSize: 13),
                          border: InputBorder.none),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 42.0, right: 42.0, bottom: 41, top: 18),
                    child: MaterialButton(
                      onPressed: () {
                        postReview();
                        analyticsService.logEvent(
                            "nps_rated", "reviewed the provider");
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      minWidth: Get.width,
                      height: 44,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                      color: GLOBAL_GREEN_COLOR,
                    ),
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[],
        );
      },
    );
  }

  fetchUserStat() async {
    await _userStatService.fetchUserStatus();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // controllerCenter.dispose();
  }
}
