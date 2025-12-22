import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/auth/create_account/components/step2/identity_tab_bar.dart';
import 'package:wazafak_app/screens/auth/create_account/components/step2/identity_upload_item.dart';
import 'package:wazafak_app/screens/main/upload_documents/upload_documents_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class UploadDocumentsScreen extends StatelessWidget {
  const UploadDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UploadDocumentsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(title: context.resources.strings.verifyYourIdentity),
            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: context.resources.strings.uploadYourDocuments,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorGrey,
                  ),
                  SizedBox(height: 8),
                  PrimaryText(
                    text: context.resources.strings.uploadClearPhotoOfIdentity,
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey7,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Obx(
              () => IdentityTabBar(
                selected: controller.selectedTab.value,
                onSelect: (selectedTab) {
                  controller.selectedTab.value = selectedTab;
                },
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => controller.selectedTab.value == "passport"
                      ? IdentityUploadItem(
                          label: context.resources.strings.passport,
                          isMandatory: true,
                          isOptional: false,
                          onClick: () {
                            controller.pickImageFromCamera(context, 'passport');
                          },
                          imagePath: controller.passportImage.value?.path,
                        )
                      : Column(
                          children: [
                            IdentityUploadItem(
                              label: context.resources.strings.frontId,
                              isMandatory: true,
                              isOptional: false,
                              onClick: () {
                                controller.pickImageFromCamera(
                                  context,
                                  'front_id',
                                );
                              },
                              imagePath: controller.frontIdImage.value?.path,
                            ),
                            SizedBox(height: 12),
                            IdentityUploadItem(
                              label: context.resources.strings.backId,
                              isMandatory: true,
                              isOptional: false,
                              onClick: () {
                                controller.pickImageFromCamera(
                                  context,
                                  'back_id',
                                );
                              },
                              imagePath: controller.backIdImage.value?.path,
                            ),
                          ],
                        ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ProgressBar();
                }

                return PrimaryButton(
                  title: context.resources.strings.uploadAndVerify,
                  onPressed: controller.uploadDocuments,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
