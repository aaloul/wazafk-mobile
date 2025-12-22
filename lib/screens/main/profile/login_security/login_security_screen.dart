import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../utils/res/AppIcons.dart';
import '../../../../utils/res/colors/hex_color.dart';
import 'components/login_security_item.dart';
import 'login_security_controller.dart';

class LoginSecurityScreen extends StatelessWidget {
  const LoginSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginSecurityController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopHeader(hasBack: true,
                title: context.resources.strings.loginAndSecurity),
            SizedBox(height: 24),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryText(
                text: context.resources.strings.passwordAndSecurity,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: context.resources.color.colorGrey,
              ),
            ),

            SizedBox(height: 16),

            LoginSecurityItem(
              title: context.resources.strings.changePassword,
              onClick: () {
                Get.toNamed(RouteConstant.changePasswordScreen);
              },
              color: HexColor("#CDE9EE"),
              border: HexColor("#CDE9EE"),
              icon: AppIcons.changePassword,
            ),

            SizedBox(height: 8),

            LoginSecurityItem(
              title: context.resources.strings.savedLogin,
              onClick: () {
                Get.toNamed(RouteConstant.savedLoginScreen);
              },
              color: HexColor("#E7F3EE"),
              border: HexColor("#E7F3EE"),
              icon: AppIcons.savedLogins,
            ),

            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryText(
                text: context.resources.strings.securityChecks,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: context.resources.color.colorGrey,
              ),
            ),

            SizedBox(height: 16),

            LoginSecurityItem(
              title: context.resources.strings.whereYoureLoggedIn,
              onClick: () {
                Get.toNamed(RouteConstant.whereLoggedInScreen);
              },
              color: HexColor("#CDE9EE"),
              border: HexColor("#CDE9EE"),
              icon: AppIcons.whereLoggedIn,
            ),

            SizedBox(height: 8),

            LoginSecurityItem(
              title: context.resources.strings.loginAlerts,
              onClick: () {
                Get.toNamed(RouteConstant.loginAlertsScreen);
              },
              color: HexColor("#E7F3EE"),
              border: HexColor("#E7F3EE"),
              icon: AppIcons.loginAlerts,
            ),
          ],
        ),
      ),
    );
  }
}
