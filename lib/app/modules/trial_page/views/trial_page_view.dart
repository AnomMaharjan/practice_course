import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/new_privacyPolicy/views/new_privacy_policy_view.dart';
import 'package:q4me/app/modules/new_termsOfUse/views/new_terms_of_use_view.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/utils/string.dart';
import '../controllers/trial_page_controller.dart';

class TrialPageView extends GetView<TrialPageController> {
  final TrialPageController _trialPageController =
      Get.put(TrialPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: GetBuilder<TrialPageController>(
        initState: _trialPageController.initialize(context),
        builder: (builder) => Center(
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            shrinkWrap: true,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 55,
                  right: 55,
                ),
                // height: size.height < 684 ? Get.height + 20 : Get.height,
                width: Get.width,
                color: Color(0xfff2f2f2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '7 Days Free Trial',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: GLOBAL_THEME_COLOR),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    trialPageContent(
                      showCheckBox: true,
                      content: Text(
                        'Pay nothing for 7 days & cancel anytime in trial',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff222222)),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    trialPageContent(
                      showCheckBox: true,
                      content: Text(
                        'Get 1 call credit per month included',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff222222)),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    trialPageContent(
                      showCheckBox: true,
                      content: Text(
                        'Instant access to 12 popular phone lines including Energy providers, Telecom providers, Airways and Local GPs.',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff222222)),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    trialPageContent(
                      showCheckBox: true,
                      content: Text(
                        'Add extra phone lines',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff222222)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                  activeColor: Colors.white,
                                  checkColor: Color(0xff8bc34c),
                                  visualDensity: VisualDensity.comfortable,
                                  side: BorderSide(
                                      color: Colors.black.withOpacity(0.2)),
                                  value:
                                      _trialPageController.termsAndConditions,
                                  onChanged: (bool value) =>
                                      _trialPageController
                                          .checkTermsAndConditions(value)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                locator<AnalyticsService>().logEvent(
                                    "terms_of_use_navigated_from_trial_page",
                                    "terms_of_use_navigated_from_trial_page");
                                Get.to(NewTermsOfUseView());
                              },
                              child: const Text(
                                "Terms of Use",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff8bc34c),
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                  visualDensity: VisualDensity.comfortable,
                                  activeColor: Colors.white,
                                  checkColor: Color(0xff8bc34c),
                                  side: BorderSide(
                                      color: Colors.black.withOpacity(0.2)),
                                  value: _trialPageController.privacyPolicy,
                                  onChanged: (bool value) =>
                                      _trialPageController
                                          .checkPrivacyPolicy(value)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              // onTap: () async {
                              //   if (!await launch(
                              //       _trialPageController.privacyPolicyLink,
                              //       enableJavaScript: true))
                              //     throw 'Could not launch ${_trialPageController.privacyPolicyLink}';
                              // },
                              onTap: () {
                                Get.to(() => NewPrivacyPolicyView());
                                locator<AnalyticsService>().logEvent(
                                    "privacy_policy_page_navigated_from_trial_page",
                                    "privacy_policy_page_navigated_from_trial_page");
                              },
                              child: const Text(
                                "Privacy Policy",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff8bc34c),
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffd2cfcf), width: 1),
                              borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        "Start your 7 days Free Trial, then\n",
                                    style: TextStyle(
                                        color: GLOBAL_THEME_COLOR,
                                        fontSize: 16.0,
                                        fontFamily: "Poppins"),
                                  ),
                                  TextSpan(
                                    text: "£0.99/ month.\n",
                                    style: TextStyle(
                                        color: GLOBAL_THEME_COLOR,
                                        fontSize: 18.0,
                                        height: 1.7,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: "Poppins"),
                                  ),
                                  TextSpan(
                                    text: "Cancel any time",
                                    style: TextStyle(
                                        color: GLOBAL_THEME_COLOR,
                                        fontSize: 18.0,
                                        height: 1.5,
                                        fontFamily: "Poppins"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.11),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(-1, 2),
                              ),
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(0, -20),
                              )
                            ]),
                        child: MaterialButton(
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          onPressed: _trialPageController.loading == true
                              ? null
                              : controller.state == ViewState.Busy
                                  ? null
                                  : () {
                                      if (_trialPageController.privacyPolicy ==
                                              true &&
                                          _trialPageController
                                                  .termsAndConditions ==
                                              true) {
                                        locator<AnalyticsService>().logEvent(
                                            "user_subscribed",
                                            "user subscribed to the application");
                                        _trialPageController
                                            .acceptTermsAndConditions();
                                      } else if (_trialPageController
                                                  .privacyPolicy !=
                                              true &&
                                          _trialPageController
                                                  .termsAndConditions !=
                                              true) {
                                        Get.snackbar("Could not register!",
                                            "Please agree to the Terms of Use and Privacy Policy",
                                            backgroundColor: Colors.white);
                                      } else if (_trialPageController
                                              .privacyPolicy !=
                                          true) {
                                        Get.snackbar("Could not register!",
                                            "Please agree to the Privacy Policy",
                                            backgroundColor: Colors.white);
                                      } else {
                                        Get.snackbar("Could not register!",
                                            "Please agree to the Terms of Use",
                                            backgroundColor: Colors.white);
                                      }
                                    },
                          minWidth: Get.width,
                          disabledColor: Color(0xff8BC34C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          color: Color(0xff8BC34C),
                          child: controller.state == ViewState.Busy
                              ? Center(
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator()),
                                )
                              : Text(
                                  'Try Free & Subscribe',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.11),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(-1, 2),
                            ),
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(0, -1),
                            )
                          ]),
                      child: MaterialButton(
                        elevation: 0,
                        minWidth: Get.width,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        color: Colors.white,
                        onPressed: () {
                          locator<AnalyticsService>().logEvent(
                              "app_closed_from_trial_page", "app closed");
                          _trialPageController.onClosePressed();
                        },
                        child: Text('Close',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff8BC34C),
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    _trialPageController.loading == true
                        ? Center(
                            child: Container(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator()),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget trialPageContent({bool showCheckBox, Widget content}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      !showCheckBox
          ? SizedBox(
              width: Get.width * 0.04,
            )
          : Column(
              children: [
                SizedBox(
                  width: Get.width * 0.04,
                  child: Text(
                    "•",
                    style: TextStyle(
                      color: Color(0xff222222),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
      SizedBox(
        width: 5,
      ),
      Flexible(child: content),
      // SizedBox(
      //   width: Get.width * 0.02,
      // )
    ]);
  }
}
