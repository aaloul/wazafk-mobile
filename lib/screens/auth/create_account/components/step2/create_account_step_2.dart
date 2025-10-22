import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/outlined_button.dart';
import '../../../../../components/primary_button.dart';
import '../../create_account_controller.dart';
import 'identity_tab_bar.dart';
import 'identity_upload_item.dart';

class CreateAccountStep2 extends StatelessWidget {
  CreateAccountStep2({super.key});

  final CreateAccountController dataController = Get.put(
    CreateAccountController(),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 8),
          Obx(
            () => IdentityTabBar(
              selected: dataController.selectedTab.value,
              onSelect: (selectedTab) {
                dataController.selectedTab.value = selectedTab;
              },
            ),
          ),

          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Obx(
                () => dataController.selectedTab.value == "passport"
                    ? IdentityUploadItem(
                        label: 'Passport',
                        isMandatory: false,
                        isOptional: false,
                        onClick: () {
                          dataController.pickImageFromCamera(
                              context, 'passport');
                        },
                        imagePath: dataController.passportImage.value?.path,
                      )
                    : Column(
                        children: [
                          IdentityUploadItem(
                            label: 'Front ID',
                            isMandatory: false,
                            isOptional: false,
                            onClick: () {
                              dataController.pickImageFromCamera(
                                  context, 'front_id');
                            },
                            imagePath: dataController.frontIdImage.value?.path,
                          ),

                          SizedBox(height: 12),

                          IdentityUploadItem(
                            label: 'Back ID',
                            isMandatory: false,
                            isOptional: false,
                            onClick: () {
                              dataController.pickImageFromCamera(
                                  context, 'back_id');
                            },
                            imagePath: dataController.backIdImage.value?.path,
                          ),
                        ],
                      ),
              ),
            ),
          ),

          SizedBox(height: 24),

          PrimaryButton(
            title: "Next",
            onPressed: () {
              dataController.verifyStep2();
            },
          ),
          SizedBox(height: 10),

          PrimaryOutlinedButton(title: "Skip", onPressed: () {}),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
