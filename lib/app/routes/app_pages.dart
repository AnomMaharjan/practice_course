import 'package:get/get.dart';

import 'package:q4me/app/modules/OTP_page/bindings/o_t_p_page_binding.dart';
import 'package:q4me/app/modules/OTP_page/views/o_t_p_page_view.dart';
import 'package:q4me/app/modules/add_credit_page/bindings/add_credit_page_binding.dart';
import 'package:q4me/app/modules/add_credit_page/views/add_credit_page_view.dart';
import 'package:q4me/app/modules/call_ended/bindings/call_ended_binding.dart';
import 'package:q4me/app/modules/call_ended/views/call_ended_view.dart';
import 'package:q4me/app/modules/call_failed/bindings/call_failed_binding.dart';
import 'package:q4me/app/modules/call_failed/views/call_failed_view.dart';
import 'package:q4me/app/modules/call_tracker/bindings/call_tracker_binding.dart';
import 'package:q4me/app/modules/call_tracker/views/call_tracker_view.dart';
import 'package:q4me/app/modules/configuration_page/bindings/configuration_page_binding.dart';
import 'package:q4me/app/modules/configuration_page/views/configuration_page_view.dart';
import 'package:q4me/app/modules/edit_profile/bindings/edit_profile_binding.dart';
import 'package:q4me/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:q4me/app/modules/frequently_asked_questions/bindings/frequently_asked_questions_binding.dart';
import 'package:q4me/app/modules/frequently_asked_questions/views/frequently_asked_questions_view.dart';
import 'package:q4me/app/modules/home/bindings/home_binding.dart';
import 'package:q4me/app/modules/home/views/home_view.dart';
import 'package:q4me/app/modules/homepage/bindings/homepage_binding.dart';
import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
import 'package:q4me/app/modules/init_page/bindings/init_page_binding.dart';
import 'package:q4me/app/modules/init_page/views/init_page_view.dart';
import 'package:q4me/app/modules/live_chat_page/bindings/live_chat_page_binding.dart';
import 'package:q4me/app/modules/live_chat_page/views/live_chat_page_view.dart';
import 'package:q4me/app/modules/login_page/bindings/login_page_binding.dart';
import 'package:q4me/app/modules/login_page/views/login_page_view.dart';
import 'package:q4me/app/modules/privacy_policy_page/bindings/privacy_policy_page_binding.dart';
import 'package:q4me/app/modules/privacy_policy_page/views/privacy_policy_page_view.dart';
import 'package:q4me/app/modules/profile_information_page/bindings/profile_information_page_binding.dart';
import 'package:q4me/app/modules/profile_information_page/views/profile_information_page_view.dart';
import 'package:q4me/app/modules/profile_page/bindings/profile_page_binding.dart';
import 'package:q4me/app/modules/profile_page/views/profile_page_view.dart';
import 'package:q4me/app/modules/record_home_view/bindings/record_home_view_binding.dart';
import 'package:q4me/app/modules/record_home_view/views/record_home_view_view.dart';
import 'package:q4me/app/modules/recordaudio/bindings/recordaudio_binding.dart';
import 'package:q4me/app/modules/recordaudio/views/recordaudio_view.dart';
import 'package:q4me/app/modules/recording_list/bindings/recording_list_binding.dart';
import 'package:q4me/app/modules/recording_list/views/recording_list_view.dart';
import 'package:q4me/app/modules/reset_password_page/bindings/reset_password_page_binding.dart';
import 'package:q4me/app/modules/reset_password_page/views/reset_password_page_view.dart';
import 'package:q4me/app/modules/service_page/bindings/service_page_binding.dart';
import 'package:q4me/app/modules/service_page/views/service_page_view.dart';
import 'package:q4me/app/modules/setting_page/bindings/setting_page_binding.dart';
import 'package:q4me/app/modules/setting_page/views/setting_page_view.dart';
import 'package:q4me/app/modules/sign_up/bindings/sign_up_binding.dart';
import 'package:q4me/app/modules/sign_up/views/sign_up_view.dart';
import 'package:q4me/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import 'package:q4me/app/modules/splash_screen/views/splash_screen_view.dart';
import 'package:q4me/app/modules/time_breakdown/bindings/time_breakdown_binding.dart';
import 'package:q4me/app/modules/time_breakdown/views/time_breakdown_view.dart';
import 'package:q4me/app/modules/tour_screen/bindings/tour_screen_binding.dart';
import 'package:q4me/app/modules/tour_screen/views/tour_screen_view.dart';
import 'package:q4me/app/modules/trial_page/bindings/trial_page_binding.dart';
import 'package:q4me/app/modules/trial_page/views/trial_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.TOUR_SCREEN,
      page: () => TourScreenView(),
      binding: TourScreenBinding(),
    ),
    GetPage(
      name: _Paths.TRIAL_PAGE,
      page: () => TrialPageView(),
      binding: TrialPageBinding(),
    ),
    GetPage(
      name: _Paths.HOMEPAGE,
      page: () => HomepageView(),
      binding: HomepageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_PAGE,
      page: () => ServicePageView(),
      binding: ServicePageBinding(),
    ),
    GetPage(
      name: _Paths.FREQUENTLY_ASKED_QUESTIONS,
      page: () => FrequentlyAskedQuestionsView(),
      binding: FrequentlyAskedQuestionsBinding(),
    ),
    GetPage(
      name: _Paths.CALL_ENDED,
      page: () => CallEndedView(),
      binding: CallEndedBinding(),
    ),
    GetPage(
      name: _Paths.INIT_PAGE,
      page: () => InitPageView(),
      binding: InitPageBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_PAGE,
      page: () => ProfilePageView(),
      binding: ProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.RECORDAUDIO,
      page: () => RecorderView(),
      binding: RecordaudioBinding(),
    ),
    GetPage(
      name: _Paths.RECORD_HOME_VIEW,
      page: () => RecorderHomeView(),
      binding: RecordHomeViewBinding(),
    ),
    GetPage(
      name: _Paths.RECORDING_LIST,
      page: () => RecordListView(),
      binding: RecordingListBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_PAGE,
      page: () => SettingPageView(),
      binding: SettingPageBinding(),
    ),
    GetPage(
      name: _Paths.CALL_TRACKER,
      page: () => CallTrackerView(),
      binding: CallTrackerBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.TIME_BREAKDOWN,
      page: () => TimeBreakdownView(),
      binding: TimeBreakdownBinding(),
    ),

    GetPage(
      name: _Paths.O_T_P_PAGE,
      page: () => OTPPageView(),
      binding: OTPPageBinding(),
    ),
    GetPage(
      name: _Paths.CALL_FAILED,
      page: () => CallFailedView(),
      binding: CallFailedBinding(),
    ),
    GetPage(
      name: _Paths.CONFIGURATION_PAGE,
      page: () => ConfigurationPageView(),
      binding: ConfigurationPageBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY_PAGE,
      page: () => PrivacyPolicyPageView(),
      binding: PrivacyPolicyPageBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_PAGE,
      page: () => ResetPasswordPageView(),
      binding: ResetPasswordPageBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CREDIT_PAGE,
      page: () => AddCreditPageView(),
      binding: AddCreditPageBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_INFORMATION_PAGE,
      page: () => ProfileInformationPageView(),
      binding: ProfileInformationPageBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.LIVE_CHAT_PAGE,
      page: () => LiveChatPageView(),
      binding: LiveChatPageBinding(),
    ),
  ];
}
