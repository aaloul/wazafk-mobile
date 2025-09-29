import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/labeled_text_field.dart';
import '../../../components/primary_text.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
                  label: 'New Password',
                  hint: 'New Password',
                  isPassword: true,
                  isMandatory: true,
                  inputType: TextInputType.phone,
                ),

                LabeledTextFiled(
                  label: 'Confirm Password',
                  hint: 'Confirm Password',
                  isPassword: true,
                  isMandatory: true,
                  inputType: TextInputType.phone,
                ),

                SizedBox(height: 42),

                PrimaryButton(title: "Change Password", onPressed: () {}),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextButton(
                      onPressed: () {},
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
