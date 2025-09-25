import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';

import '../screens/splash/splash_screen.dart';

List<GetPage> getPages = [
  GetPage(
    name: RouteConstant.splashScreen,
    page: () => const SplashScreen(),
    transition: Transition.downToUp,
  ),

  // GetPage(
  //   name: RouteConstant.loginScreen,
  //   page: () => LoginScreen(),
  //   transition: Transition.rightToLeftWithFade,
  // ),
];
