import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/auth/reset_password/reset_password_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

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
                  child: Image.asset(
                    AppIcons.newPasswordScreenImage,
                    height: Get.width / 2,
                    width: Get.width / 1.5,
                  ),
                ),

                SizedBox(height: 32),

                PrimaryText(
                  text: Resources
                      .of(context)
                      .strings
                      .newPassword,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlackMain,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32),

                LabeledTextFiled(
                  label: Resources
                      .of(context)
                      .strings
                      .newPassword,
                  hint: Resources
                      .of(context)
                      .strings
                      .newPassword,
                  isPassword: true,
                  isMandatory: true,
                  inputType: TextInputType.visiblePassword,
                  controller: dataController.newPasswordController,
                ),

                LabeledTextFiled(
                  label: Resources
                      .of(context)
                      .strings
                      .confirmPassword,
                  hint: Resources
                      .of(context)
                      .strings
                      .confirmPassword,
                  isPassword: true,
                  isMandatory: true,
                  inputType: TextInputType.visiblePassword,
                  controller: dataController.confirmPasswordController,
                ),


                SizedBox(
                    height: 32),

                Obx(
                      () =>
                  dataController.isLoading.value
                      ? ProgressBar()
                      : PrimaryButton(
                    title: Resources
                        .of(context)
                        .strings
                        .resetMyPassword,
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
                        text: Resources
                            .of(context)
                            .strings
                            .back,
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
