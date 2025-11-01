import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

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
            child: Padding(
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
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    textColor: context.resources.color.colorGrey8,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),
                  // Image
                  Image.asset(image, width: 120, height: 120),

                  SizedBox(height: 20),

                  // Description
                  PrimaryText(
                    text: description,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),

                  SizedBox(height: 24),

                  // Button
                  PrimaryButton(
                    title: buttonText,
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
