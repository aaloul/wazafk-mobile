import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/labeled_text_field.dart';
import '../../../components/primary_text.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

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
                    AppIcons.phoneScreenImage,
                    height: Get.width / 2,
                    width: Get.width / 1.5,
                  ),
                ),

                SizedBox(height: 32),

                PrimaryText(
                  text: "Login/Register",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlackMain,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24),

                LabeledTextFiled(
                  label: 'Phone Number',
                  hint: '',
                  isPassword: false,
                  isMandatory: true,
                  inputType: TextInputType.phone,
                ),
                SizedBox(height: 20),

                PrimaryText(
                  text:
                      "Message and date rates may apply. By continuing, you agree to our Terms of Use and Privacy Policy.",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: context.resources.color.colorGrey3,
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: 40),

                PrimaryButton(title: "Continue", onPressed: () {
                  Get.toNamed(RouteConstant.loginPasswordScreen);
                }),
                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
