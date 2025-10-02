import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'change_language_controller.dart';
import 'components/irem_language.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeLanguageController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Change Language'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: controller.languages.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final language = controller.languages[index];

                  return Obx(
                    () => LanguageItem(
                      onSelectLanguage: (languageCode) {
                        controller.selectedLanguage.value = languageCode;
                      },
                      language: language,
                      isSelected:
                          controller.selectedLanguage.value == language['code'],
                    ),
                  );
                },
              ),
            ),

            Obx(
              () => controller.isLoading.value
                  ? ProgressBar()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: PrimaryButton(
                        title: "Apply Language",
                        onPressed: () {
                          controller.changeLanguage(
                            controller.selectedLanguage.value,
                          );
                        },
                      ),
                    ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
