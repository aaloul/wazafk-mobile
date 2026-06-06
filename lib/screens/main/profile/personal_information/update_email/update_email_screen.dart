import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/auth/verification/components/verification_pin_widget.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'update_email_controller.dart';

class UpdateEmailScreen extends StatelessWidget {
  const UpdateEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateEmailController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.colorWhite,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.updateEmailAddress),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: PrimaryText(
                  text: strings.sendEmailConfirmation,
                  fontSize: 13,
                  textColor: colors.colorGrey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => _EmailField(
                  controller: controller.emailController,
                  errorText: controller.emailError.value,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => (controller.isCheckingEmail.value ||
                        controller.isSendingOtp.value)
                    ? const ProgressBar()
                    : PrimaryButton(
                        title: strings.save,
                        onPressed: () async {
                          final ok = await controller.verifyEmailAndSendOtp();
                          if (ok && context.mounted) {
                            await _OtpSheet.show(context, controller);
                          }
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller, required this.errorText});

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: colors.colorWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError ? colors.colorRed2 : colors.colorGrey4,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                text: strings.emailAddress,
                fontSize: 11,
                textColor: colors.colorGrey,
              ),
              TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.colorBlack,
                ),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
              ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: PrimaryText(
              text: errorText!,
              fontSize: 12,
              textColor: colors.colorRed2,
            ),
          ),
      ],
    );
  }
}

class _OtpSheet {
  static Future<void> show(
    BuildContext context,
    UpdateEmailController controller,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.resources.color.colorWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: _OtpSheetBody(controller: controller),
      ),
    );
  }
}

class _OtpSheetBody extends StatefulWidget {
  const _OtpSheetBody({required this.controller});

  final UpdateEmailController controller;

  @override
  State<_OtpSheetBody> createState() => _OtpSheetBodyState();
}

class _OtpSheetBodyState extends State<_OtpSheetBody> {
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.colorGrey2,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryText(
            text: strings.otpTitle,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const SizedBox(height: 24),
          VerificationPinWidget(
            onPinChange: (pin, completed) {
              setState(() => _otp = pin);
              if (completed) {
                widget.controller.submitOtp(pin);
              }
            },
          ),
          const SizedBox(height: 20),
          PrimaryText(
            text: strings.otpSentToNewEmail,
            fontSize: 12,
            textColor: colors.colorGrey,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Obx(() => widget.controller.isSubmittingOtp.value
              ? const ProgressBar()
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.controller.sendOtp(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: PrimaryText(
                      text: strings.resendOtp,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorPrimary,
                    ),
                  ),
                )),
          if (_otp.length == 4)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: PrimaryButton(
                title: strings.save,
                onPressed: () => widget.controller.submitOtp(_otp),
              ),
            ),
        ],
      ),
    );
  }
}
