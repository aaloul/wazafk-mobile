import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

/// Illustrated success bottom sheet shown after an action API succeeds
/// (design p43 / p92 / p226 / p233 …): drag handle, title, illustration,
/// divider, message, and a full-width action button.
class SuccessMessageSheet extends StatelessWidget {
  const SuccessMessageSheet({
    super.key,
    required this.title,
    required this.illustration,
    required this.message,
    this.buttonText,
    this.onButton,
  });

  final String title;
  final String illustration;
  final String message;
  final String? buttonText;
  final VoidCallback? onButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: context.resources.color.colorGrey15,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryText(
              text: title,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              textColor: context.resources.color.colorBlack,
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset(
                illustration,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 28),
            Divider(height: 1, color: context.resources.color.colorGrey4),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: PrimaryText(
                text: message,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                textColor: context.resources.color.colorGrey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(
                title: buttonText ?? Resources.of(context).strings.ok,
                height: 52,
                borderRadius: 14,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                onPressed: onButton ?? () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience opener.
Future<void> showSuccessMessageSheet({
  required String title,
  required String illustration,
  required String message,
  String? buttonText,
  VoidCallback? onButton,
}) {
  return Get.bottomSheet(
    SuccessMessageSheet(
      title: title,
      illustration: illustration,
      message: message,
      buttonText: buttonText,
      onButton: onButton,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
  );
}
