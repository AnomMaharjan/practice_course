import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/add_credit_page/bindings/add_credit_page_binding.dart';
import 'package:q4me/app/modules/add_credit_page/views/add_credit_page_view.dart';
import 'package:q4me/app/modules/time_breakdown/bindings/time_breakdown_binding.dart';
import 'package:q4me/app/modules/time_breakdown/views/time_breakdown_view.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';
import 'package:q4me/globals/globals.dart' as globals;

class UserStatComponent extends StatelessWidget {
  final SharedPreferencesManager _sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            globals.addCreditStatus.value = false;
            locator<AnalyticsService>()
                .logEvent("add_credits_clicked", "add credits clicked");

            Get.offAll(() => AddCreditPageView(),
                transition: Transition.noTransition,
                binding: AddCreditPageBinding());
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 55,
                    child: SvgPicture.asset(
                      'assets/svgs/mobile.svg',
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    heightFactor: 2.45,
                    widthFactor: 1.2,
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 24,
                      width: 24,
                      // padding: const EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _sharedPreferencesManager
                                    .getInt("remainingCredit") <=
                                0
                            ? Color(0xffBF4E30)
                            : Color(0xff8BC34C),
                      ),
                      child: Center(
                        child: Text(
                          _sharedPreferencesManager
                              .getInt("remainingCredit")
                              .toStringAsFixed(0),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          GestureDetector(
              onTap: () {
                locator<AnalyticsService>().logEvent(
                    "time_breakdown_clicked", "time breakdown clicked");
                Get.to(
                    () => TimeBreakdownView(
                          from: 0,
                        ),
                    binding: TimeBreakdownBinding());
              },
              child: SizedBox(
                  height: 38, child: Image.asset("assets/images/qicon2.png"))),
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 6.0),
            child: (_sharedPreferencesManager.getDouble("hoursSaved") == 0.0)
                ? RichText(
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.3,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "0",
                        style: TextStyle(
                          color: GLOBAL_GREEN_COLOR,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "Hr",
                        style: TextStyle(
                          color: GLOBAL_GREEN_COLOR,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]))
                : _sharedPreferencesManager.getDouble("hoursSaved") < 1.0 &&
                        _sharedPreferencesManager.getDouble("hoursSaved") != 0.0
                    ? RichText(
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.3,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text:
                                "${(_sharedPreferencesManager.getDouble("hoursSaved") * 60).round().toString()}",
                            style: TextStyle(
                              color: GLOBAL_GREEN_COLOR,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: "Min",
                            style: TextStyle(
                              color: GLOBAL_GREEN_COLOR,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]))
                    : RichText(
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.3,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text:
                                "${_sharedPreferencesManager.getDouble("hoursSaved").toPrecision(1)}",
                            style: TextStyle(
                              color: GLOBAL_GREEN_COLOR,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: "Hrs",
                            style: TextStyle(
                              color: GLOBAL_GREEN_COLOR,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ])),
          ),
        ]),
      ],
    );
  }
}
