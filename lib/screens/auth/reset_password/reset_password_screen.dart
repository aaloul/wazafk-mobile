import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/auth/reset_password/reset_password_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/labeled_text_field.dart';
import '../../../components/primary_text.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController dataController = Get.put(
      ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),

                Center(
                  child: Container(
                    child: Image.asset(
                      AppIcons.newPasswordScreenImage,
                      height: Get.width / 2,
                      width: Get.width / 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 32),

                PrimaryText(
                  text: "Enter New Password,",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlackMain,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32),

                LabeledTextFiled(
                  label: 'OTP',
                  hint: 'Enter OTP',
                  isPassword: false,
                  isMandatory: true,
                  inputType: TextInputType.number,
                  controller: dataController.otpController,
                ),

                LabeledTextFiled(
                  label: 'New Password',
                  hint: 'New Password',
                  isPassword: true,
                  isMandatory: true,
                  inputType: TextInputType.visiblePassword,
                  controller: dataController.newPasswordController,
                ),

                LabeledTextFiled(
                  label: 'Confirm Password',
                  hint: 'Confirm Password',
                  isPassword: true,
                  isMandatory: true,
                  inputType: TextInputType.visiblePassword,
                  controller: dataController.confirmPasswordController,
                ),

                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryText(
                      text: "Didn't Receive OTP?",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorGrey3,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 2),
                    GestureDetector(
                      onTap: () {
                        dataController.requestPasswordReset();
                      },
                      child: PrimaryText(
                        text: "Resend Code",
                        fontSize: 14,
                        isUnderLined: true,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorPrimary,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 42),

                Obx(
                      () =>
                  dataController.isLoading.value
                      ? ProgressBar()
                      : PrimaryButton(
                    title: "Change Password",
                    onPressed: () {
                      dataController.confirmPasswordReset();
                    },
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: PrimaryText(
                        text: 'Back',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorBlackMain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
