import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../utils/res/AppIcons.dart';
import 'components/login_security_item.dart';
import 'login_security_controller.dart';

class LoginSecurityScreen extends StatelessWidget {
  const LoginSecurityScreen({super.key});

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    Get.put(LoginSecurityController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopHeader(
              hasBack: true,
              title: context.resources.strings.loginAndSecurity,
            ),
            const SizedBox(height: 24),

            // Password & Security section

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all( 16),
              decoration: _cardDecoration,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: context.resources.strings.passwordAndSecurity,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: context.resources.color.colorBlack4,
                    ),
                    const SizedBox(height: 12),

                    LoginSecurityItem(
                      title: context.resources.strings.changePassword,
                      onClick: () =>
                          Get.toNamed(RouteConstant.changePasswordScreen),
                      icon: AppIcons.changePassword,
                    ),

                  ],
                ),

            ),

            const SizedBox(height: 24),


            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: _cardDecoration,
              padding: EdgeInsets.all(16),
              child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    PrimaryText(
                      text: context.resources.strings.securityChecks,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: context.resources.color.colorBlack4,
                    ),
                    const SizedBox(height: 12),

                    LoginSecurityItem(
                      title: context.resources.strings.whereYoureLoggedIn,
                      onClick: () =>
                          Get.toNamed(RouteConstant.whereLoggedInScreen),

                      icon: AppIcons.whereLoggedIn,
                    ),

                    Container(
                      width: double.infinity,
                      height: 1,
                        margin: EdgeInsets.symmetric(vertical: 10),
                      color: context.resources.color.colorGrey25,
                    ),

                    LoginSecurityItem(
                      title: context.resources.strings.loginAlerts,
                      onClick: () =>
                          Get.toNamed(RouteConstant.loginAlertsScreen),

                      icon: AppIcons.loginAlerts,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
