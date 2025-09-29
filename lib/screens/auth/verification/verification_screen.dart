import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/primary_text.dart';
import 'components/verification_pin_widget.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

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
                      AppIcons.verifyScreenImage,
                      height: Get.width / 2,
                      width: Get.width / 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 32),

                PrimaryText(
                  text: "Enter Verification Code",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlackMain,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                PrimaryText(
                  text: "OTP Has been Sent to your Phone Number.",
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  textColor: context.resources.color.colorGrey,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32),

                VerificationPinWidget(
                  onPinChange: (String pin, bool completed) {},
                ),

                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryText(
                      text: "Didn’t Receive OTP?",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorGrey3,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 2),
                    PrimaryText(
                      text: "Resend Code",
                      fontSize: 14,
                      isUnderLined: true,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorPrimary,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),

                SizedBox(height: 42),

                PrimaryButton(title: "Verify", onPressed: () {}),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
