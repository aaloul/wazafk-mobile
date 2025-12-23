import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/auth/verification/verification_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../components/primary_text.dart';
import 'components/verification_pin_widget.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({super.key});

  final VerificationController dataController = Get.put(
      VerificationController());

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
                ),,

                SizedBox(height: 32)PrimaryText(
                  text: Resources.of(context).strings.enterVerificationCode,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlackMain,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                PrimaryText(
                  text: Resources
                      .of(context)
                      .strings
                      .otpHasBeenSent,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  textColor: context.resources.color.colorGrey,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32),

                VerificationPinWidget(
                  onPinChange: (String pin, bool completed) {
                    dataController.otp.value = pin;
                  },
                ),

                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryText(
                      text: Resources
                          .of(context)
                          .strings
                          .didntReceiveOtp,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorGrey3,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 2),
                    GestureDetector(
                      onTap: () {
                        dataController.resendOTP();
                      },
                      child: Obx(
                            () =>
                        dataController.isResending.value
                            ? SizedBox(
                          width: 14,
                          height: 14,)
                            : PrimaryText(
                          text: Resources
                              .of(context)
                              .strings
                              .resendCode,
                          fontSize: 14,
                          isUnderLined: true,
                          fontWeight: FontWeight.w500,
                          textColor: context.resources.color.colorPrimary,
                          textAlign: TextAlign.start,
                        ),
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
                    title: Resources
                        .of(context)
                        .strings
                        .verify,
                    onPressed: () {
                      dataController.verifyOTP();
                    },
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
