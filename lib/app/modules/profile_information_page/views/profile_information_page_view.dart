import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:q4me/app/modules/sign_up/views/sign_up_view.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';

import '../../../../widgets/Custom_TextFormField.dart';
import '../controllers/profile_information_page_controller.dart';
import 'package:q4me/globals/globals.dart' as globals;

class ProfileInformationPageView
    extends GetView<ProfileInformationPageController> {
  final ProfileInformationPageController _profileInformationPageController =
      Get.put(ProfileInformationPageController());

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _profileInformationPageController.initialize(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          _profileInformationPageController.addressFinderPressed.value = false;
        }
      },
      child: Scaffold(
        body: GetBuilder<ProfileInformationPageController>(
          builder: (builder) => Obx(
            () => Form(
              key: _profileInformationPageController.formKey,
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _profileInformationPageController.analyticsService
                            .logEvent("user_information_skipped",
                                "skipped user information");
                        locator<SharedPreferencesManager>()
                            .putBool("userInfoUpdated", true);
                        Get.toNamed(Routes.HOMEPAGE);
                        globals.currentIndex.value = 0;
                        globals.topupStatus.value = false;
                        globals.addCreditStatus.value = false;
                      },
                      child: Text(
                        "SKIP",
                        style: TextStyle(
                            color: GLOBAL_GREEN_COLOR,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 55),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: const [
                              Text("User Information", style: HEADING_STYLE),
                              SizedBox(height: 10),
                              Text(
                                '''Input from the information will be provided to the provider when necessary.''',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.7, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 21),
                        const Text("First Name", style: SUB_HEADING_STYLE),
                        const SizedBox(height: 6),
                        CustomTextFormField(
                          onTap: () {
                            _profileInformationPageController
                                .addressFinderPressed.value = false;
                          },
                          validator: null,
                          controller: _profileInformationPageController
                              .firstNameController,
                          hintText: 'eg. John',
                        ),
                        const SizedBox(height: 20),
                        const Text("Last Name", style: SUB_HEADING_STYLE),
                        const SizedBox(height: 6),
                        CustomTextFormField(
                            onTap: () {
                              _profileInformationPageController
                                  .addressFinderPressed.value = false;
                            },
                            validator: null,
                            hintText: "eg: Harrison",
                            controller: _profileInformationPageController
                                .lastNameController),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _profileInformationPageController
                                      .addressManuallyPressed.value ==
                                  false
                              ? [
                                  const Text("Address Finder",
                                      style: SUB_HEADING_STYLE),
                                  const SizedBox(height: 6),
                                  CustomTextFormField(
                                    onEditingCompleted: () {
                                      _profileInformationPageController
                                          .addressFinderPressed.value = false;
                                      FocusScope.of(context).unfocus();
                                    },
                                    valueChanged: (value) {
                                      _profileInformationPageController.getAddress(
                                          postCode:
                                              _profileInformationPageController
                                                  .addressFinderController
                                                  .text);
                                    },
                                    onTap: () =>
                                        _profileInformationPageController
                                            .addressFinderPressed.value = true,
                                    validator: null,
                                    hintText: "Enter your address or postcode",
                                    controller:
                                        _profileInformationPageController
                                            .addressFinderController,
                                  ),
                                ]
                              : [
                                  const Text("Address Line 1",
                                      style: SUB_HEADING_STYLE),
                                  const SizedBox(height: 6),
                                  CustomTextFormField(
                                    onEditingCompleted: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: null,
                                    hintText: "eg. Flat 4",
                                    controller:
                                        _profileInformationPageController
                                            .addressLine1Controller,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text("Address Line 2",
                                      style: SUB_HEADING_STYLE),
                                  const SizedBox(height: 6),
                                  CustomTextFormField(
                                    onEditingCompleted: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: null,
                                    hintText: "eg. 51 Peach Street",
                                    controller:
                                        _profileInformationPageController
                                            .addressLine2Controller,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text("Postcode",
                                      style: SUB_HEADING_STYLE),
                                  const SizedBox(height: 6),
                                  CustomTextFormField(
                                    onEditingCompleted: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: null,
                                    hintText: "eg. RG40 1FA",
                                    controller:
                                        _profileInformationPageController
                                            .postCode,
                                  ),
                                  Column(
                                    children: _profileInformationPageController
                                            .addressManuallyPressedErrorPopUp
                                            .value
                                        ? [
                                            const SizedBox(height: 31),
                                            CustomBox(
                                              child: InCorrectTextPopUp(
                                                textChild: Text(
                                                  'Invalid Address',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              color: Color(0xfff8d0c9),
                                            ),
                                            const SizedBox(height: 14.4),
                                          ]
                                        : [],
                                  ),
                                ],
                        ),
                        SizedBox(
                          height: _profileInformationPageController
                                      .addressFinderPressed.value ==
                                  true
                              ? 2
                              : 16,
                        ),
                        _profileInformationPageController
                                .addressFinderPressed.value
                            ? const SizedBox()
                            : MaterialButton(
                                onPressed: () {
                                  _profileInformationPageController
                                          .addressManuallyPressed.value =
                                      !_profileInformationPageController
                                          .addressManuallyPressed.value;
                                  _profileInformationPageController
                                      .addressFinderController.text = '';
                                  _profileInformationPageController
                                      .continueBtnColorStatus.value = false;
                                },
                                padding: EdgeInsets.zero,
                                height: 0,
                                child: Text(
                                  _profileInformationPageController
                                              .addressManuallyPressed.value ==
                                          true
                                      ? 'Search for another address'
                                      : 'Enter address manually',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: GLOBAL_GREEN_COLOR,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        _profileInformationPageController
                                    .addressFinderPressed.value ==
                                false
                            ? SizedBox(
                                height: _profileInformationPageController
                                            .addressManuallyPressed.value ==
                                        true
                                    ? !_profileInformationPageController
                                            .addressManuallyPressedErrorPopUp
                                            .value
                                        ? Get.height * 0.08
                                        : Get.height * 0
                                    : Get.height * 0.2,
                              )
                            : CustomBox(
                                paddingStatus: false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 14),
                                      child: const Text(
                                        'Keep typing to display more results below',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: (_profileInformationPageController
                                              .addressFinderList.isEmpty
                                          ? 1
                                          : (_profileInformationPageController
                                                      .addressFinderList
                                                      .length <
                                                  5
                                              ? _profileInformationPageController
                                                  .addressFinderList.length
                                              : 5)),
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              GestureDetector(
                                        onTap: () {
                                          _profileInformationPageController
                                                  .addressFinderController
                                                  .text =
                                              _profileInformationPageController
                                                      .addressFinderList[index]
                                                      .labels1
                                                      .toString() +
                                                  _profileInformationPageController
                                                      .addressFinderList[index]
                                                      .labels0
                                                      .toString() +
                                                  _profileInformationPageController
                                                      .addressFinderList[index]
                                                      .count
                                                      .toString();
                                          _profileInformationPageController
                                              .addressFinderPressed
                                              .value = false;
                                        },
                                        child: AddressFinderTextOption(
                                          label1: _profileInformationPageController
                                                  .addressFinderList.isEmpty
                                              ? " "
                                              : _profileInformationPageController
                                                  .addressFinderList[index]
                                                  .labels1
                                                  .toString(),
                                          label0: _profileInformationPageController
                                                  .addressFinderList.isEmpty
                                              ? " "
                                              : _profileInformationPageController
                                                  .addressFinderList[index]
                                                  .labels0
                                                  .toString(),
                                          count: _profileInformationPageController
                                                  .addressFinderList.isEmpty
                                              ? " "
                                              : _profileInformationPageController
                                                  .addressFinderList[index]
                                                  .countNo
                                                  .toString(),

                                          //  _profileInformationPageController
                                          //         .addressFinderList[index]
                                          //         .labels[1]
                                          //         .toString() +
                                          //     ", " +
                                          //     _profileInformationPageController
                                          //         .addressFinderList[index]
                                          //         .labels[0]
                                          //         .toString() +
                                          //     " " +
                                          //     _profileInformationPageController
                                          //         .addressFinderList[index]
                                          //         .count
                                          //         .toString() +
                                          //     " Addresses",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: _profileInformationPageController
                                  .addressFinderPressed.value
                              ? 25
                              : 0,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          minWidth: Get.width,
                          height: 44,
                          child: Center(
                            child: Text(
                              'Continue',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          disabledColor: Color(0xffd2cfcf),
                          color: GLOBAL_GREEN_COLOR,
                          onPressed:
                              (_profileInformationPageController
                                          .firstNameController.text.isNotEmpty ||
                                      _profileInformationPageController
                                          .lastNameController.text.isNotEmpty ||
                                      _profileInformationPageController
                                          .addressFinderController
                                          .text
                                          .isNotEmpty ||
                                      _profileInformationPageController
                                          .addressLine1Controller
                                          .text
                                          .isNotEmpty ||
                                      _profileInformationPageController
                                          .addressLine2Controller
                                          .text
                                          .isNotEmpty ||
                                      _profileInformationPageController
                                          .postCode.text.isNotEmpty)
                                  ? !_profileInformationPageController
                                          .addressManuallyPressed.value
                                      ? () {
                                          _profileInformationPageController
                                              .postAddress();
                                        }
                                      : () {
                                          print("eta bata aira ho");
                                          _profileInformationPageController
                                              .postAdressManualy();
                                        }
                                  : null,
                          // color: _profileInformationPageController
                          //     .changeContinueBtnColor(),
                        ),
                        const SizedBox(height: 88),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddressFinderTextOption extends StatelessWidget {
  const AddressFinderTextOption({
    Key key,
    this.label0,
    this.label1,
    this.count,
  }) : super(key: key);

  final String label0;
  final String label1;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 14),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: label1,
                          style: const TextStyle(
                              color: Color(0xff949594), fontSize: 12)),
                      TextSpan(
                        text: label0,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff222222),
                            fontSize: 12),
                      ),
                      TextSpan(
                          text: count,
                          style: const TextStyle(
                              color: Color(0xff949594), fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/svgs/angle-down-solid.svg'))
          ],
        ),
      ],
    );
  }
}

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    Key key,
    @required this.text,
    @required this.textStyle,
    @required this.onTap,
    this.status = false,
  }) : super(key: key);

  final String text;
  final TextStyle textStyle;
  final VoidCallback onTap;
  final bool status;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: Get.width,
        child: Center(child: Text(text, style: textStyle)),
        decoration: BoxDecoration(
            color: status ? Color(0xff79c631) : Color(0xffd2cfcf),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 6,
                  spreadRadius: 1,
                  color: Colors.grey.withOpacity(0.4))
            ]),
      ),
    );
  }
}
