import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// "You've reached your … limit" sheet — design p174 (job posts) and p114
/// (work packs): title, illustration, the price of one more, and a Top up
/// button.
class LimitReachedSheet extends StatelessWidget {
  const LimitReachedSheet({
    super.key,
    required this.title,
    required this.illustration,
    required this.message,
    this.onTopUp,
  });

  final String title;
  final String illustration;
  final String message;
  final VoidCallback? onTopUp;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String illustration,
    required String message,
    VoidCallback? onTopUp,
  }) {
    return Get.bottomSheet(
      LimitReachedSheet(
        title: title,
        illustration: illustration,
        message: message,
        onTopUp: onTopUp,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.colorGrey25,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryText(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: colors.colorBlack,
            ),
            const SizedBox(height: 24),
            Image.asset(illustration, height: 120, fit: BoxFit.contain),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryText(
                text: message,
                fontSize: 14,
                textAlign: TextAlign.center,
                textColor: colors.colorGrey8,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(
                title: context.resources.strings.topUpTitle,
                onPressed: () {
                  Get.back();
                  if (onTopUp != null) {
                    onTopUp!();
                  } else {
                    Get.toNamed(RouteConstant.topUpScreen);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
