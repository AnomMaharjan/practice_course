import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:q4me/app/components/top_card.dart';
import 'package:q4me/app/modules/homepage/bindings/homepage_binding.dart';
import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
import 'package:q4me/app/modules/new_privacyPolicy/views/new_privacy_policy_view.dart';
import 'package:q4me/app/modules/new_termsOfUse/views/new_terms_of_use_view.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/mixins/connectivity_mixin.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import 'package:q4me/globals/globals.dart' as globals;
import 'package:q4me/widgets/reusable_button.dart';
import 'package:q4me/widgets/user_stats_components.dart';
import '../controllers/add_credit_page_controller.dart';

class AddCreditPageView extends GetView<AddCreditPageController>
    with Connection {
  final AddCreditPageController _addCreditPageController =
      Get.put(AddCreditPageController());
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _addCreditPageController.initialize(context);
    double itemHeight;
    var size = MediaQuery.of(context).size;
    if (size.height > 684 && size.height < 896) {
      itemHeight = (size.height - kToolbarHeight - 24) / 3.5 + 18;
    } else if (size.height < 684) {
      itemHeight = (size.height - kToolbarHeight - 24) / 2.8;
    } else if (size.height >= 896 && size.height < 926) {
      itemHeight = (size.height - kToolbarHeight - 24) / 4;
    } else {
      itemHeight = (size.height - kToolbarHeight - 24) / 4.2;
    }

    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        from: 3,
      ),
      backgroundColor: Color(0xfff2f2f2),
      body: GetBuilder<AddCreditPageController>(
        builder: (builder) => Stack(
          children: [
            Container(
              height: itemHeight * 2,
              width: size.width,
              decoration: BoxDecoration(
                color: Color(0xff13253A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Stack(
                  children: [
                    TopCard(height: Get.height * 0.2),
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      padding: EdgeInsets.only(top: 16, left: 24, right: 24),
                      decoration: BoxDecoration(
                        color: Color(0xfff2f2f2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Obx(() => globals.addCreditStatus == false
                              ? Container(
                                  padding:
                                      EdgeInsets.only(top: Get.height * 0.03),
                                  width: Get.width,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: size.height < 684 ? 220 : 250,
                                        height: size.height < 684 ? 220 : 250,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                locator<SharedPreferencesManager>()
                                                    .getInt('remainingCredit')
                                                    .toString(),
                                                style: TextStyle(
                                                    color: locator<SharedPreferencesManager>()
                                                                .getInt(
                                                                    'remainingCredit') ==
                                                            0
                                                        ? Color(0xffBF4E30)
                                                        : Color(0xffba9fe2),
                                                    fontSize: 48,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Poppins")),
                                            Text('Credits',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "Poppins",
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        )),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      locator<SharedPreferencesManager>()
                                                  .getInt('remainingCredit') !=
                                              0
                                          ? const Text(
                                              'You have \ncredits in your account.',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          : const Text(
                                              'Add more \ncredits to make a call',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      locator<SharedPreferencesManager>()
                                                  .getInt('remainingCredit') ==
                                              0
                                          ? const Text('1 credit = 1 call',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 18))
                                          : Text(
                                              '${locator<SharedPreferencesManager>().getInt('remainingCredit')} credits = ${locator<SharedPreferencesManager>().getInt('remainingCredit')} calls',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      locator<SharedPreferencesManager>()
                                                  .getInt('remainingCredit') ==
                                              0
                                          ? const SizedBox()
                                          : ReusableButton(
                                              txt: const Text('Make a call',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                              onPressed: () {
                                                Get.offAll(() => HomepageView(),
                                                    transition: Transition
                                                        .noTransition);
                                              },
                                              bgColor: Color(0xff8BC34C),
                                            ),
                                      const SizedBox(height: 8),
                                      ReusableButton(
                                        txt: Text('Add Credits',
                                            style: TextStyle(
                                              color: locator<SharedPreferencesManager>()
                                                          .getInt(
                                                              'remainingCredit') ==
                                                      0
                                                  ? Colors.white
                                                  : const Color(0xff8BC34C),
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        onPressed: () {
                                          globals.addCreditStatus.value = true;
                                        },
                                        bgColor:
                                            locator<SharedPreferencesManager>()
                                                        .getInt(
                                                            'remainingCredit') ==
                                                    0
                                                ? const Color(0xff8BC34C)
                                                : Colors.white,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                )
                              : _addCreditPageController.state == ViewState.Busy
                                  ? Container(
                                      height: 400,
                                      child: Center(
                                          child: CircularProgressIndicator()))
                                  : _addCreditPageController
                                              .additionalCredits.isEmpty ||
                                          _addCreditPageController
                                                  .additionalCredits ==
                                              null
                                      ? Container(
                                          height: 400,
                                          child: Center(
                                              child: Text(
                                                  "Something went wrong.")),
                                        )
                                      : Container(
                                          color: Color(0xfff2f2f2),
                                          width: Get.width,
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: Get.height * 0.03)),
                                              const Text('Credit Options',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Color(0xff13253a))),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 5,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xff13253a),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          child: Center(
                                                            child: const Text(
                                                                'Additional Credit',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Column(
                                                            children:
                                                                List.generate(
                                                          _addCreditPageController
                                                              .additionalCredits
                                                              .length,
                                                          (index) => Column(
                                                            children: [
                                                              Container(
                                                                height: 45,
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xffffffff),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4)),
                                                                child: Row(
                                                                  children: [
                                                                    Radio(
                                                                      value: _addCreditPageController
                                                                          .additionalCredits[
                                                                              index]
                                                                          .credit,
                                                                      groupValue: _addCreditPageController
                                                                          .selectedCredit
                                                                          .value,
                                                                      onChanged:
                                                                          _addCreditPageController
                                                                              .selectCredit,
                                                                      activeColor:
                                                                          Color(
                                                                              0xff8BC34C),
                                                                    ),
                                                                    Text(
                                                                        _addCreditPageController
                                                                            .additionalCredits[
                                                                                index]
                                                                            .credit
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600))
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 6,
                                                              )
                                                            ],
                                                          ),
                                                        ))
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xff13253a),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          child: const Center(
                                                            child: Text('Cost',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Column(
                                                          children:
                                                              List.generate(
                                                                  _addCreditPageController
                                                                      .additionalCredits
                                                                      .length,
                                                                  (index) =>
                                                                      Column(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                45,
                                                                            decoration:
                                                                                BoxDecoration(color: Color(0xffffffff), borderRadius: BorderRadius.circular(4)),
                                                                            child:
                                                                                Center(
                                                                              child: Text('£' + _addCreditPageController.additionalCredits[index].price.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                6,
                                                                          ),
                                                                        ],
                                                                      )),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.02,
                                              ),
                                              ReusableButton(
                                                txt: _addCreditPageController
                                                            .loading ==
                                                        true
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : const Text("Buy Credits",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                onPressed:
                                                    _addCreditPageController
                                                                .loading ==
                                                            true
                                                        ? null
                                                        : () {
                                                            locator<AnalyticsService>()
                                                                .logEvent(
                                                                    "credit_bought",
                                                                    "credit bought");
                                                            _addCreditPageController
                                                                .purchase();
                                                          },
                                                bgColor: Color(0xff8BC34C),
                                              ),
                                              SizedBox(
                                                height: 26,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    // onTap: () async {
                                                    //   launch(
                                                    //       _addCreditPageController
                                                    //           .termsAndConditionsLink,
                                                    //       enableJavaScript:
                                                    //           true,
                                                    //       forceWebView: true);
                                                    // },
                                                    onTap: () => Get.to(
                                                        NewTermsOfUseView()),
                                                    child: Text(
                                                      'Terms of Use',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    // onTap: () async {
                                                    //   launch(
                                                    //       _addCreditPageController
                                                    //           .privacyPolicyLink,
                                                    //       enableJavaScript:
                                                    //           true,
                                                    //       forceWebView: true);
                                                    // },
                                                    onTap: () => Get.to(
                                                        NewPrivacyPolicyView()),
                                                    child: Text(
                                                      'Privacy Policy',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ))
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: Get.width * 0.05,
                              right: Get.width * 0.05,
                              top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [UserStatComponent()],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                      ),
                      // top: Platform.isIOS
                      //     ? size.height < 684
                      //         ? 12
                      //         : 8
                      //     : 12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            splashRadius: 1,
                            onPressed: () {
                              Get.offAll(() => HomepageView(),
                                  binding: HomepageBinding(),
                                  transition: Transition.noTransition);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xfa8BC34C),
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
