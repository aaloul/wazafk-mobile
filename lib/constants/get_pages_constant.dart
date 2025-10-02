import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/profile/notification_settings/notification_settings_screen.dart';

import '../screens/auth/change_password/change_password_screen.dart';
import '../screens/auth/create_account/create_account_screen.dart';
import '../screens/auth/login_password/login_password_screen.dart';
import '../screens/auth/onboarding/onboarding_screen.dart';
import '../screens/auth/phone_number/phone_number_screen.dart';
import '../screens/auth/select_portal/select_portal_screen.dart';
import '../screens/auth/splash/splash_screen.dart';
import '../screens/auth/verification/verification_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/common/terms/terms_screen.dart';
import '../screens/main/main_navigation_screen.dart';
import '../screens/main/profile/about_us/about_us_screen.dart';
import '../screens/main/profile/add_address/add_address_screen.dart';
import '../screens/main/profile/change_language/change_language_screen.dart';
import '../screens/main/profile/give_feedback/give_feedback_screen.dart';
import '../screens/main/profile/help_center/help_center_screen.dart';
import '../screens/main/profile/login_security/login_security_screen.dart';
import '../screens/main/profile/my_addresses/my_addresses_screen.dart';
import '../screens/main/profile/my_documents/my_documents_screen.dart';
import '../screens/main/profile/packs/packs_screen.dart';
import '../screens/main/profile/payments_earnings/payments_earnings_screen.dart';
import '../screens/main/profile/personal_information/personal_information_screen.dart';
import '../screens/main/profile/privacy_sharing/privacy_sharing_screen.dart';
import '../screens/main/profile/services/services_screen.dart';
import '../screens/main/profile/share_app/share_app_screen.dart';
import '../screens/main/profile/way_of_payment/way_of_payment_screen.dart';
import '../screens/main/profile/working_days/working_days_screen.dart';

List<GetPage> getPages = [
  GetPage(
    name: RouteConstant.splashScreen,
    page: () => const SplashScreen(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: RouteConstant.onboardingScreen,
    page: () => const OnboardingScreen(),
    transition: Transition.rightToLeftWithFade,
  ),

  GetPage(
    name: RouteConstant.phoneNumberScreen,
    page: () => PhoneNumberScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.termsScreen,
    page: () => TermsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.loginPasswordScreen,
    page: () => LoginPasswordScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.verificationScreen,
    page: () => VerificationScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.changePasswordScreen,
    page: () => ChangePasswordScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.createAccountScreen,
    page: () => CreateAccountScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.selectPortalScreen,
    page: () => SelectPortalScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.mainNavigationScreen,
    page: () => MainNavigationScreen(),
    transition: Transition.rightToLeftWithFade,
  ),

  GetPage(
    name: RouteConstant.chatScreen,
    page: () => ChatScreen(),
    transition: Transition.rightToLeftWithFade,
  ),

  // Profile screens
  GetPage(
    name: RouteConstant.personalInformationScreen,
    page: () => PersonalInformationScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.myDocumentsScreen,
    page: () => MyDocumentsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.myAddressesScreen,
    page: () => MyAddressesScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.profileNotificationsScreen,
    page: () => NotificationSettingsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.loginSecurityScreen,
    page: () => LoginSecurityScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.paymentsEarningsScreen,
    page: () => PaymentsEarningsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.privacySharingScreen,
    page: () => PrivacySharingScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.changeLanguageScreen,
    page: () => ChangeLanguageScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.wayOfPaymentScreen,
    page: () => WayOfPaymentScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.workingDaysScreen,
    page: () => WorkingDaysScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.aboutUsScreen,
    page: () => AboutUsScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.helpCenterScreen,
    page: () => HelpCenterScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.giveFeedbackScreen,
    page: () => GiveFeedbackScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.servicesScreen,
    page: () => ServicesScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.packsScreen,
    page: () => PacksScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.shareAppScreen,
    page: () => ShareAppScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
  GetPage(
    name: RouteConstant.addAddressScreen,
    page: () => AddAddressScreen(),
    transition: Transition.rightToLeftWithFade,
  ),
];
