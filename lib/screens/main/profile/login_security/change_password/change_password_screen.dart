import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Change Password'),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledTextFiled(
                      controller: controller.currentPasswordController,
                      hint: 'Old Password',
                      label: 'Old Password',
                      isMandatory: true,
                      isPassword: true,
                      inputType: TextInputType.visiblePassword,
                    ),
                    LabeledTextFiled(
                      controller: controller.newPasswordController,
                      hint: 'New Password',
                      label: 'New Password',
                      isMandatory: true,
                      isPassword: true,
                      inputType: TextInputType.visiblePassword,
                    ),
                    LabeledTextFiled(
                      controller: controller.confirmPasswordController,
                      hint: 'Confirm Password',
                      label: 'Confirm Password',
                      isMandatory: true,
                      isPassword: true,
                      inputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Obx(
              () => controller.isLoading.value
                  ? ProgressBar()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: PrimaryButton(
                        title: "Change Password",
                        onPressed: () {
                          controller.changePassword();
                        },
                      ),
                    ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
