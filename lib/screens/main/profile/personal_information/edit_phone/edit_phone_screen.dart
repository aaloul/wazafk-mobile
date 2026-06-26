import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/phone_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/auth/verification/components/verification_pin_widget.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'edit_phone_controller.dart';

class EditPhoneScreen extends StatelessWidget {
  const EditPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditPhoneController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Figma p137) — circular back, left-aligned title + subtitle.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.colorGrey4, width: 1),
                      ),
                      child: Image.asset(AppIcons.back3, width: 24),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryText(
                    text: strings.editPhoneNumber,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textColor: colors.colorBlack4,
                  ),
                  const SizedBox(height: 6),
                  PrimaryText(
                    text: strings.phoneNumberWillReplace,
                    fontSize: 13,
                    textColor: colors.colorGrey,
                  ),
                ],
              ),
            ),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 20),

            // Phone field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhoneTextFiled(
                    hint: strings.phoneNumber,
                    controller: controller.phoneController,
                    onCCChanged: controller.onCountryChanged,
                  ),
                  Obx(() => controller.phoneError.value != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: PrimaryText(
                            text: controller.phoneError.value!,
                            fontSize: 12,
                            textColor: colors.colorRed2,
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Save
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => controller.isSendingOtp.value
                    ? const ProgressBar()
                    : PrimaryButton(
                        title: strings.save,
                        onPressed: () async {
                          final ok = await controller.validateAndSendOtp();
                          if (ok && context.mounted) {
                            await _OtpSheet.show(context, controller);
                          }
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpSheet {
  static Future<void> show(
    BuildContext context,
    EditPhoneController controller,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.resources.color.colorWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _OtpSheetBody(controller: controller),
      ),
    );
  }
}

class _OtpSheetBody extends StatefulWidget {
  const _OtpSheetBody({required this.controller});

  final EditPhoneController controller;

  @override
  State<_OtpSheetBody> createState() => _OtpSheetBodyState();
}

class _OtpSheetBodyState extends State<_OtpSheetBody> {
  String _otp = '';

  Future<void> _verify(String otp) async {
    final ok = await widget.controller.submitOtp(otp);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(); // close OTP sheet
      await _SuccessSheet.show(context);
      Get.back(result: true); // leave the edit screen
    }
  }

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
              if (completed) _verify(pin);
            },
          ),
          const SizedBox(height: 20),
          PrimaryText(
            text: strings.otpSentToNewNumber,
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
                onPressed: () => _verify(_otp),
              ),
            ),
        ],
      ),
    );
  }
}

class _SuccessSheet {
  static Future<void> show(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.colorWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
            const SizedBox(height: 22),
            PrimaryText(
              text: strings.phoneNumber,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: colors.colorBlack,
            ),
            const SizedBox(height: 16),
            PrimaryText(
              text: strings.phoneNumberChangedSuccess,
              fontSize: 13,
              textColor: colors.colorGrey,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              title: strings.ok,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
