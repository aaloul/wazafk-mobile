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

  @override
  Widget build(BuildContext context) {
    Get.put(LoginSecurityController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.colorWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopHeader(hasBack: true, title: strings.loginAndSecurity),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 16),
            _SectionCard(
              title: strings.password,
              children: [
                LoginSecurityItem(
                  title: strings.changePassword,
                  onClick: () =>
                      Get.toNamed(RouteConstant.changePasswordScreen),
                  icon: AppIcons.changePassword,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: strings.securityChecks,
              children: [
                LoginSecurityItem(
                  title: strings.whereYoureLoggedIn,
                  onClick: () =>
                      Get.toNamed(RouteConstant.whereLoggedInScreen),
                  icon: AppIcons.whereLoggedIn,
                ),
                _Divider(),
                LoginSecurityItem(
                  title: strings.loginAlerts,
                  onClick: () =>
                      Get.toNamed(RouteConstant.loginAlertsScreen),
                  icon: AppIcons.loginAlerts,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: context.resources.color.colorGrey4,
    );
  }
}
