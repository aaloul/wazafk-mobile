import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/onboarding/onboarding_screen.dart';

import '../screens/phone_number/phone_number_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/terms/terms_screen.dart';

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
];
