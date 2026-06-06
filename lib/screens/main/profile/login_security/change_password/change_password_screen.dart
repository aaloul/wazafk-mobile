import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.changePassword),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                    children: [
                      LabeledTextFiled(
                        controller: controller.currentPasswordController,
                        hint: strings.oldPassword,
                        label: strings.oldPassword,
                        isMandatory: true,
                        isPassword: true,
                        inputType: TextInputType.visiblePassword,
                      ),
                      LabeledTextFiled(
                        controller: controller.newPasswordController,
                        hint: strings.newPassword,
                        label: strings.newPassword,
                        isMandatory: true,
                        isPassword: true,
                        inputType: TextInputType.visiblePassword,
                      ),
                      LabeledTextFiled(
                        controller: controller.confirmPasswordController,
                        hint: strings.confirmPassword,
                        label: strings.confirmPassword,
                        isMandatory: true,
                        isPassword: true,
                        inputType: TextInputType.visiblePassword,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: ProgressBar(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PrimaryButton(
                        title: strings.changePassword,
                        onPressed: controller.changePassword,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.toNamed(RouteConstant.phoneNumberScreen),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryText(
                      text: strings.forgotPassword,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      textColor: colors.colorGrey,
                    ),
                    const SizedBox(width: 4),
                    PrimaryText(
                      text: strings.reset,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorPrimary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
