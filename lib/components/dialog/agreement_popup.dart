import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../outlined_button.dart';

class AgreementPopup extends StatelessWidget {
  const AgreementPopup({
    super.key,
    required this.title,
    required this.agreeText,
    required this.disAgreeText,
    required this.onAgree,
    required this.loading,
    this.agreeColor,
  });

  final String title;
  final String agreeText;
  final String disAgreeText;
  final Function onAgree;
  final RxBool loading;
  final Color? agreeColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => SafeArea(
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          PrimaryText(
            text: title,
            fontWeight: FontWeight.w500,
            height: 1.3,
            fontSize: 16,
          ),
          const SizedBox(height: 16),
          Obx(
            () => loading.value
                ? const ProgressBar()
                : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: PrimaryOutlinedButton(
                          height: 45,
                          margin: 0,
                          color: context.resources.color.colorWhite.withOpacity(
                            .5,
                          ),
                          borderColor: context.resources.color.colorGrey8,
                          textColor: context.resources.color.colorGrey,
                          title: disAgreeText,
                          onPressed: () {
                            Navigator.pop(Get.context!);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: PrimaryButton(
                          height: 45,
                          title: agreeText,
                          color:
                              agreeColor ?? context.resources.color.colorRed2,
                          textColor: context.resources.color.colorWhite,
                          onPressed: onAgree,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    ),
  );
}
