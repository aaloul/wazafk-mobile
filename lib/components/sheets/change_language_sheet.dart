import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/profile/change_language/change_language_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ChangeLanguageSheet extends StatelessWidget {
  const ChangeLanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeLanguageController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colors.colorGrey2,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        PrimaryText(
          text: strings.changeLanguage,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          textColor: colors.colorBlack,
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ProgressBar(color: colors.colorPrimary),
            );
          }
          return Column(
            children: controller.languages.map((language) {
              final isSelected =
                  controller.selectedLanguage.value == language['code'];
              return _LanguageRow(
                label: language['name']!,
                isSelected: isSelected,
                onTap: () {
                  controller.changeLanguage(language['code']!);
                  Get.back();
                },
              );
            }).toList(),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: isSelected ? colors.colorPrimaryLight : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            if (isSelected)
              Container(
                width: 3,
                height: 20,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: colors.colorPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            PrimaryText(
              text: label,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              textColor:
                  isSelected ? colors.colorPrimary : colors.colorBlack,
            ),
          ],
        ),
      ),
    );
  }
}
