import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/auth/login_password/login_password_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/labeled_text_field.dart';
import '../../../components/primary_text.dart';

class LoginPasswordScreen extends StatelessWidget {
  LoginPasswordScreen({super.key});

  final LoginPasswordController dataController = Get.put(
      LoginPasswordController());

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
                      AppIcons.passwordScreenImage,
                      height: Get.width / 2,
                      width: Get.width / 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 24),

                PrimaryText(
                  text: "Welcome,",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlackMain,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),

                Obx(
                      () =>
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppIcons.phone, width: 12),
                            SizedBox(width: 4),
                            PrimaryText(
                              text: dataController.mobile,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                  ),
                ),

                SizedBox(height: 24),

                LabeledTextFiled(
                  label: 'Password',
                  hint: '',
                  isPassword: true,
                  isMandatory: true,
                  inputType: TextInputType.visiblePassword,
                  controller: dataController.passwordController,
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    PrimaryText(
                      text: "Forget Your Password?",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorGrey3,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 2),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          RouteConstant.changePasswordScreen,
                          arguments: {'mobile': dataController.mobile},
                        );
                      },
                      child: PrimaryText(
                        text: "Rest My Password",
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
                    title: "Login",
                    onPressed: () {
                      dataController.login();
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
