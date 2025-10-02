import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/auth/splash/splash_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../utils/Prefs.dart';
import '../../../utils/res/AppIcons.dart';
import '../../../utils/res/colors/hex_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController dataController = Get.put(SplashController());

  @override
  void initState() {
    showSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor();

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: "splash",
                        child: Image.asset(AppIcons.logo, width: Get.width / 2),
                      ),

                      SizedBox(height: 10),

                      Image.asset(AppIcons.name, width: Get.width / 2),

                      SizedBox(height: 24),

                      Obx(
                        () => dataController.isBannersLoading.value
                            ? ProgressBar()
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showSplash() async {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (Prefs.getLoggedIn) {
        Get.offAllNamed(RouteConstant.mainNavigationScreen);
      } else {
        Get.offAllNamed(RouteConstant.phoneNumberScreen);
      }
    });
  }

  void changeStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Get.context!.resources.color.colorPrimary,
        // navigation bar color
        statusBarColor: HexColor('#FFFFFF'),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
