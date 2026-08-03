import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Bottom sheet shown after posting a job, service or pack. Typography follows
/// the design file, which sets these screens in DM Sans.
const String _designFont = 'DM Sans Text';

class SuccessSheet {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String image,
    required String description,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      // The illustration makes this taller than the default 9/16 cap.
      isScrollControlled: true,
      builder: (context) => PopScope(
        canPop: false,
        child: Container(
          decoration: BoxDecoration(
            color: context.resources.color.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.resources.color.colorGrey8,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Title
                  PrimaryText(
                    text: title,
                    fontFamily: _designFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorBlack,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 28),
                  // Illustration, sized as in the design.
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Image.asset(image, height: 180, fit: BoxFit.contain),
                  ),

                  SizedBox(height: 28),
                  Divider(height: 1, color: context.resources.color.colorGrey4),
                  SizedBox(height: 20),

                  // Description
                  PrimaryText(
                    text: description,
                    fontFamily: _designFont,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey26,
                    textAlign: TextAlign.center,
                    height: 1.4,
                    maxLines: 3,
                  ),

                  SizedBox(height: 24),

                  // Button
                  PrimaryButton(
                    title: buttonText,
                    fontFamily: _designFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    onPressed: () {
                      Navigator.pop(context);
                      onButtonPressed?.call();
                    },
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
