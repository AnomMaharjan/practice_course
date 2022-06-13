import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/utils/string.dart';
import 'package:q4me/widgets/country_code_picker.dart';

import '../../../../widgets/Custom_TextFormField.dart';
import '../../profile_information_page/views/profile_information_page_view.dart';
import '../../sign_up/views/sign_up_view.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  final EditProfileController _editProfileController =
      Get.put(EditProfileController());

  final String from;
  EditProfileView({
    @required this.from,
  });
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _editProfileController.initialize(context);
    String countryCode;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          _editProfileController.addressFinderPressed.value = false;
          _editProfileController.newPasswordPressed.value = false;
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: ListView(
          shrinkWrap: true,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  splashRadius: 1,
                  padding: const EdgeInsets.only(left: 18, top: 27),
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Color(0xff8BC34C)),
            ),
            if (from == 'phoneNumber')
              EnterNumber(context, countryCode,
                  _editProfileController.phoneNumberController)
            else if (from == 'addressFinder')
              EditAddressFinder(context)
            else if (from == 'password')
              EditPassword(context),
            from == 'phoneNumber'
                ? SizedBox(height: Get.height * 0.4)
                : Obx(
                    () => from == 'addressFinder'
                        ? SizedBox(
                            height: _editProfileController
                                    .addressManuallyPressed.value
                                ? Get.height * 0.26
                                : Get.height * 0.5)
                        : SizedBox(
                            height: _editProfileController
                                        .newPasswordPressed.value ||
                                    _editProfileController
                                            .addressManuallyPressedErrorPopUp
                                            .value ==
                                        true
                                ? Get.height * 0.06
                                : Get.height * 0.3,
                          ),
                  ),
            from == 'addressFinder'
                ? Obx(
                    () =>
                        // _editProfileController.state == ViewState.Busy
                        //     ? Center(child: CircularProgressIndicator.adaptive())
                        //     :
                        Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55.0),
                      child: CustomBtn(
                        onTap: () {
                          if (!_editProfileController
                              .addressManuallyPressed.value) {
                            print('object');
                            _editProfileController.postAddress();
                          } else {
                            print('1');
                            _editProfileController.postAdressManualy();
                          }
                        },
                        status: !_editProfileController
                                    .addressManuallyPressed.value &&
                                !_editProfileController
                                    .continueBtnColorStatus.value
                            ? false
                            : _editProfileController.changeBtnColorForAddress(),
                        text: 'Save',
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55.0),
                      child: _editProfileController.state == ViewState.Busy
                          ? Center(child: CircularProgressIndicator.adaptive())
                          : CustomBtn(
                              onTap: () {
                                if (from == 'phoneNumber') {
                                  _editProfileController.checkOTPStatus(
                                      phoneNumber:
                                          _editProfileController.countryCode +
                                              _editProfileController
                                                  .phoneNumberController.text,
                                      context: context);
                                } else if (from == 'password') {
                                  // _editProfileController.checkConditions();
                                  _editProfileController.changePw();
                                  // _editProfileController.changePw();
                                  // : null;
                                }
                              },
                              status: from == 'phoneNumber'
                                  ? _editProfileController
                                      .changeBtnColorForPhone()
                                  : _editProfileController
                                      .changeBtnColorForPassword(),
                              text: 'Save',
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget EditPassword(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: const Text(
                "Edit New Password",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: GLOBAL_THEME_COLOR),
              ),
            ),
            const SizedBox(height: 29),
            const Text(
              'Current Password',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              onTap: () {
                _editProfileController.newPasswordPressed.value = false;
              },
              errorStatus: _editProfileController.currentPasswordCorrect.value,
              obsecure: _editProfileController.hideCurrentPassword.value
                  ? false
                  : true,
              suffixIcon: GestureDetector(
                onTap: () => _editProfileController.hideCurntPwEyeBtn(),
                child: SvgPicture.asset(
                  _editProfileController.hideCurrentPassword.value
                      ? "assets/svgs/eye.svg"
                      : "assets/svgs/eye-off.svg",
                  fit: BoxFit.scaleDown,
                ),
              ),
              validator: (text) {
                if (text.isEmpty)
                  return 'Address Finder cannot be empty';
                else
                  return null;
              },
              hintText: 'eg: xxxxxx',
              controller: _editProfileController.currentPwController,
            ),
            const SizedBox(height: 20),
            const Text(
              'New Password',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              onEditingCompleted: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                  _editProfileController.addressFinderPressed.value = false;
                  _editProfileController.newPasswordPressed.value = false;
                }
              },
              errorStatus: _editProfileController.newPasswordCorrect.value,
              valueChanged: (value) {
                print(value);

                if (_editProfileController.newPwController.text.length >= 8)
                  _editProfileController.lengthValidator.value = true;
                else
                  _editProfileController.lengthValidator.value = false;

                if (RegExp(r'^(?=.*?[A-Z])')
                    .hasMatch(_editProfileController.newPwController.text))
                  _editProfileController.capitalLetterValidator.value = true;
                else
                  _editProfileController.capitalLetterValidator.value = false;

                if (RegExp(r'^(?=.*?[0-9])')
                    .hasMatch(_editProfileController.newPwController.text))
                  _editProfileController.numberValidator.value = true;
                else
                  _editProfileController.numberValidator.value = false;

                if (RegExp(r'^(?=.*?[!@#\$&*~])')
                    .hasMatch(_editProfileController.newPwController.text))
                  _editProfileController.specialLetterValidator.value = true;
                else
                  _editProfileController.specialLetterValidator.value = false;
              },
              obsecure:
                  _editProfileController.hidePassword.value ? false : true,
              suffixIcon: GestureDetector(
                onTap: () => _editProfileController.hideNewPwEyeBtn(),
                child: SvgPicture.asset(
                  _editProfileController.hidePassword.value
                      ? "assets/svgs/eye.svg"
                      : "assets/svgs/eye-off.svg",
                  fit: BoxFit.scaleDown,
                ),
              ),
              validator: (text) {
                if (text.isEmpty)
                  return 'Address Finder cannot be empty';
                else
                  return null;
              },
              onTap: () =>
                  _editProfileController.newPasswordPressed.value = true,
              hintText: 'eg: xxxxxx',
              controller: _editProfileController.newPwController,
            ),
            _editProfileController.newPasswordPressed.value == true
                ? Column(
                    children: [
                      const SizedBox(height: 2),
                      CustomBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Password Requirements",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 9),
                            passwordValidationWidget(
                              content: "At least 8 characters",
                              status:
                                  _editProfileController.lengthValidator.value,
                            ),
                            passwordValidationWidget(
                              content: "At least 1 number",
                              status:
                                  _editProfileController.numberValidator.value,
                            ),
                            passwordValidationWidget(
                              content: "At least 1 capital letter",
                              status: _editProfileController
                                  .capitalLetterValidator.value,
                            ),
                            passwordValidationWidget(
                              content: "At least 1 special character",
                              status: _editProfileController
                                  .specialLetterValidator.value,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                : const SizedBox(height: 20),
            const Text(
              'Confirm New Password',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              onTap: () {
                _editProfileController.newPasswordPressed.value = false;
              },
              errorStatus: _editProfileController.confirmPasswordCorrect.value,
              obsecure: _editProfileController.hideConfirmPassword.value
                  ? false
                  : true,
              suffixIcon: GestureDetector(
                onTap: () {
                  _editProfileController.newPasswordPressed.value = false;
                  _editProfileController.hideConfirmEyeBtn();
                },
                child: SvgPicture.asset(
                  _editProfileController.hideConfirmPassword.value
                      ? "assets/svgs/eye.svg"
                      : "assets/svgs/eye-off.svg",
                  fit: BoxFit.scaleDown,
                ),
              ),
              validator: (text) {
                if (text.isEmpty)
                  return 'Address Finder cannot be empty';
                else
                  return null;
              },
              hintText: 'eg: xxxxxx',
              controller: _editProfileController.confirmNewController,
            ),
            const SizedBox(height: 20),
            Column(
              children: _editProfileController
                          .addressManuallyPressedErrorPopUp.value ==
                      true
                  ? [
                      const SizedBox(height: 31),
                      CustomBox(
                        child: InCorrectTextPopUp(
                          textChild: Text(
                            _editProfileController.errorText.value.toString(),
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
      ),
    );
  }

  Widget EditAddressFinder(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: const Text(
                "Edit Address",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: GLOBAL_THEME_COLOR),
              ),
            ),
            const SizedBox(height: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: !_editProfileController.addressManuallyPressed.value
                  ? [
                      const Text("Address Finder", style: SUB_HEADING_STYLE),
                      const SizedBox(height: 6),
                      CustomTextFormField(
                        onEditingCompleted: () {
                          _editProfileController.addressFinderPressed.value =
                              false;
                          _editProfileController.continueBtnColorStatus.value =
                              true;
                          FocusScope.of(context).unfocus();
                        },
                        valueChanged: (value) {
                          _editProfileController.continueBtnColorStatus.value =
                              true;
                          _editProfileController.getAddress(
                              postCode: _editProfileController
                                  .addressFinderController.text);
                        },
                        onTap: () => _editProfileController
                            .addressFinderPressed.value = true,
                        validator: (text) {
                          if (text.isEmpty)
                            return 'Address Finder cannot be empty';
                          else
                            return null;
                        },
                        hintText: "Enter your address or postcode",
                        controller:
                            _editProfileController.addressFinderController,
                      ),
                    ]
                  : [
                      const Text("Address Line 1", style: SUB_HEADING_STYLE),
                      const SizedBox(height: 6),
                      CustomTextFormField(
                        onEditingCompleted: () {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (text) {
                          if (text.isEmpty)
                            return 'Address Finder cannot be empty';
                          else
                            return null;
                        },
                        hintText: "eg. Flat 4",
                        controller:
                            _editProfileController.addressLine1Controller,
                      ),
                      const SizedBox(height: 20),
                      const Text("Address Line 2", style: SUB_HEADING_STYLE),
                      const SizedBox(height: 6),
                      CustomTextFormField(
                        onEditingCompleted: () {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (text) {
                          if (text.isEmpty)
                            return 'Address Finder cannot be empty';
                          else
                            return null;
                        },
                        hintText: "eg. 51 Peach Street",
                        controller:
                            _editProfileController.addressLine2Controller,
                      ),
                      const SizedBox(height: 20),
                      const Text("Postcode", style: SUB_HEADING_STYLE),
                      const SizedBox(height: 6),
                      CustomTextFormField(
                        onEditingCompleted: () {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (text) {
                          if (text.isEmpty)
                            return 'Address Finder cannot be empty';
                          else
                            return null;
                        },
                        hintText: "eg. RG40 1FA",
                        controller: _editProfileController.postCode,
                      ),
                    ],
            ),
            _editProfileController.addressFinderPressed.value == false
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: CustomBox(
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
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: (_editProfileController
                                    .addressFinderList.isEmpty
                                ? 1
                                : (_editProfileController
                                            .addressFinderList.length <
                                        5
                                    ? _editProfileController
                                        .addressFinderList.length
                                    : 5)),
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                              onTap: () {
                                _editProfileController
                                    .addressFinderPressed.value = false;
                                _editProfileController.addressFinderController
                                    .text = _editProfileController
                                        .addressFinderList[index].labels1
                                        .toString() +
                                    _editProfileController
                                        .addressFinderList[index].labels0
                                        .toString();
                                _editProfileController.postalCode =
                                    _editProfileController
                                        .addressFinderList[index].labels1
                                        .toString();
                                _editProfileController.address1 =
                                    _editProfileController
                                        .addressFinderList[index].labels0
                                        .toString();
                                _editProfileController
                                    .continueBtnColorStatus.value = true;
                              },
                              child: AddressFinderTextOption(
                                label0: _editProfileController
                                        .addressFinderList.isEmpty
                                    ? " "
                                    : _editProfileController
                                        .addressFinderList[index].labels0
                                        .toString(),
                                label1: _editProfileController
                                        .addressFinderList.isEmpty
                                    ? " "
                                    : _editProfileController
                                        .addressFinderList[index].labels1
                                        .toString(),
                                count: _editProfileController
                                        .addressFinderList.isEmpty
                                    ? " "
                                    : _editProfileController
                                        .addressFinderList[index].countNo
                                        .toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            _editProfileController.addressFinderPressed.value
                ? SizedBox()
                : MaterialButton(
                    onPressed:
                        _editProfileController.addressManuallyPressed.value
                            ? () {
                                _editProfileController
                                        .continueBtnColorStatus.value =
                                    !_editProfileController
                                        .continueBtnColorStatus.value;
                                _editProfileController
                                    .addressManuallyPressed.value = false;

                                print(_editProfileController
                                    .continueBtnColorStatus.value);
                              }
                            : () {
                                _editProfileController
                                    .addressFinderController.text = '';
                                _editProfileController.addressLine1Controller
                                    .clear();
                                _editProfileController.addressLine2Controller
                                    .clear();
                                _editProfileController.postCode.clear();
                                _editProfileController
                                    .continueBtnColorStatus.value = false;
                                _editProfileController
                                    .addressManuallyPressed.value = true;
                                print(
                                    'address ${_editProfileController.addressManuallyPressed.value}');
                                print(_editProfileController
                                    .continueBtnColorStatus.value);
                              },
                    padding: EdgeInsets.zero,
                    height: 0,
                    child: Text(
                      _editProfileController.addressManuallyPressed.value
                          ? 'Search for another address'
                          : 'Enter address manually',
                      style: TextStyle(
                        fontSize: 13,
                        color: GLOBAL_GREEN_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget EnterNumber(BuildContext context, String countryCode,
      TextEditingController phoneNumberController) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xfff2f2f2), borderRadius: BorderRadius.circular(20)),
      height: 285,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Edit Phone Number",
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: GLOBAL_THEME_COLOR),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //countrycodepicker
                    child: CountryCodePicker(
                      padding: EdgeInsets.zero,
                      textStyle: const TextStyle(
                          fontSize: 13, color: Color(0xff222222)),
                      showFlag: true,
                      flagWidth:
                          MediaQuery.of(context).size.height > 812 ? 55 : 50,
                      deviceSize: MediaQuery.of(context).size.height,
                      flagDecoration:
                          const BoxDecoration(shape: BoxShape.circle),
                      initialSelection: _editProfileController.countryCode,
                      favorite: ["+44", 'GB'],
                      showDropDownButton: true,
                      onInit: (value) {
                        _editProfileController.countryCode = value.toString();
                      },
                      onChanged: (value) {
                        _editProfileController.countryCode = value.toString();
                        print("value: $countryCode");
                      },
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintStyle: const TextStyle(fontSize: 13),
                          border: InputBorder.none,
                          counterText: "",
                          filled: true,
                          contentPadding:
                              const EdgeInsets.only(left: 14.0, bottom: 10),
                          hintText: 'Enter Mobile Number',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide:
                                  const BorderSide(color: Colors.white))),
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'Phone Number cannot be empty';
                        } else
                          return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
