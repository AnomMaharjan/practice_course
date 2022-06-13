import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/call_ended/views/call_ended_view.dart';
import 'package:q4me/app/modules/edit_profile/bindings/edit_profile_binding.dart';
import 'package:q4me/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:q4me/app/modules/new_privacyPolicy/views/new_privacy_policy_view.dart';
import 'package:q4me/app/modules/sign_up/views/sign_up_view.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/string.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  final ProfilePageController _profilePageController =
      Get.put(ProfilePageController());
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _profilePageController.initialize(context);
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: SafeArea(
          child: GetBuilder<ProfilePageController>(builder: (_) {
            return _profilePageController.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator.adaptive())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              splashRadius: 1,
                              padding: const EdgeInsets.only(left: 8),
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back_ios),
                              color: Color(0xff8BC34C)),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 130,
                              width: 130,
                              padding: const EdgeInsets.all(6),
                              child: Image(
                                image: const AssetImage(
                                    "assets/images/profile.png"),
                                height: 108,
                                width: 108,
                              ),
                            ),
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: GestureDetector(
                            //     onTap: () => Get.to(() => CallEndedView(
                            //           minutesSaved: '3 mins',
                            //           imageName: '',
                            //         )),
                            //     child:
                            //         SvgPicture.asset('assets/svgs/upload.svg'),
                            //   ),
                            // ),
                          ],
                        ),
                        Text(
                          _profilePageController.profileData.name.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xff13253a),
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                        Text(
                          _profilePageController.profileData.emailDetail,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff2d2d2d),
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 55.0, right: 55, top: 40),
                          child: Column(
                            children: [
                              CustomProfileTile(
                                heading: 'Phone Number',
                                content:
                                    _profilePageController.profileData.phoneNo,
                                onTap: () {
                                  Get.to(
                                    () => EditProfileView(
                                      from: 'phoneNumber',
                                    ),
                                    arguments: {
                                      'phoneNo': _profilePageController
                                          .profileData.phoneNo
                                    },
                                    transition: Transition.cupertino,
                                    binding: EditProfileBinding(),
                                  );
                                  _profilePageController.analyticsService
                                      .logEvent("edit_phone_number_event",
                                          "edit phone number");
                                },
                              ),
                              CustomDivider(),
                              CustomProfileTile(
                                onTap: () => Get.to(
                                  () => EditProfileView(
                                    from: 'addressFinder',
                                  ),
                                  arguments: {
                                    'phoneNo': _profilePageController
                                        .profileData.phoneNo
                                  },
                                  transition: Transition.cupertino,
                                  binding: EditProfileBinding(),
                                ),
                                heading: 'Address',
                                content: _profilePageController
                                    .profileData.addressDetail,
                              ),
                              CustomDivider(),
                              locator<SharedPreferencesManager>()
                                      .getBool("isSocial")
                                  ? SizedBox()
                                  : CustomProfileTile(
                                      heading: 'Password',
                                      content: 'password',
                                      onTap: () => Get.to(
                                        () => EditProfileView(
                                          from: 'password',
                                        ),
                                        arguments: {
                                          'phoneNo': _profilePageController
                                              .profileData.phoneNo
                                        },
                                        transition: Transition.cupertino,
                                        binding: EditProfileBinding(),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          }),
        ),
        bottomNavigationBar: BottomNavBar(from: 3));
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 27),
        Divider(
          color: Color(0xffcccccc),
          thickness: 1,
        ),
        const SizedBox(height: 27),
      ],
    );
  }
}

class CustomProfileTile extends StatelessWidget {
  const CustomProfileTile({
    Key key,
    @required this.heading,
    @required this.content,
    @required this.onTap,
  }) : super(key: key);

  final String heading, content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: TextStyle(
                  fontSize: 16,
                  color: SUB_HEADING_THEME_COLOR,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              heading != 'Password'
                  ? Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 14,
                          color: TEXT_COLOR,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: Wrap(
                        children:
                            List.generate(content.length, (index) => Text('')),
                      ),
                    )
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: CustomBox(
              child: SvgPicture.asset('assets/svgs/edit_pencil.svg'),
            ),
          ),
        ),
      ],
    );
  }
}
