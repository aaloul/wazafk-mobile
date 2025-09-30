import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';

import '../screens/auth/change_password/change_password_screen.dart';
import '../screens/auth/create_account/create_account_screen.dart';
import '../screens/auth/login_password/login_password_screen.dart';
import '../screens/auth/onboarding/onboarding_screen.dart';
import '../screens/auth/phone_number/phone_number_screen.dart';
import '../screens/auth/select_portal/select_portal_screen.dart';
import '../screens/auth/splash/splash_screen.dart';
import '../screens/auth/verification/verification_screen.dart';
import '../screens/common/terms/terms_screen.dart';

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
];
