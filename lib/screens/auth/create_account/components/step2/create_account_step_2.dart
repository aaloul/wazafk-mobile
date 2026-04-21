import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

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
                    ? Column(
                        children: [
                          IdentityUploadItem(
                            label: Resources.of(context).strings.passport,
                            isMandatory: false,
                            isOptional: false,
                            onClick: () {
                              dataController.pickImageFromCamera(
                                context,
                                'passport',
                              );
                            },
                            imagePath: dataController.passportImage.value?.path,
                          ),

                          SizedBox(height: 24),

                          Text.rich(
                            TextSpan(
                              text: Resources.of(context).strings.verifyPassport,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: context.resources.color.colorGrey26,
                              ),
                              children: [
                                TextSpan(
                                  text: Resources.of(
                                    context,
                                  ).strings.onceApproved,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: context.resources.color.colorGrey26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          IdentityUploadItem(
                            label: Resources.of(context).strings.frontId,
                            isMandatory: false,
                            isOptional: false,
                            onClick: () {
                              dataController.pickImageFromCamera(
                                context,
                                'front_id',
                              );
                            },
                            imagePath: dataController.frontIdImage.value?.path,
                          ),

                          SizedBox(height: 12),

                          IdentityUploadItem(
                            label: Resources.of(context).strings.backId,
                            isMandatory: false,
                            isOptional: false,
                            onClick: () {
                              dataController.pickImageFromCamera(
                                context,
                                'back_id',
                              );
                            },
                            imagePath: dataController.backIdImage.value?.path,
                          ),

                          SizedBox(height: 24),

                          Text.rich(
                            TextSpan(
                              text: Resources.of(context).strings.verifyUserId,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: context.resources.color.colorGrey26,
                              ),
                              children: [
                                TextSpan(
                                  text: Resources.of(
                                    context,
                                  ).strings.onceApproved,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: context.resources.color.colorGrey26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          SizedBox(height: 16),

          PrimaryButton(
            title: Resources.of(context).strings.next,
            onPressed: () {
              dataController.verifyStep2();
            },
          ),

          // SizedBox(height: 10),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextButton(
                onPressed: () {
                  dataController.index.value = 3;
                },
                child: PrimaryText(
                  text: Resources.of(context).strings.skip,
                  isUnderLined: true,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: context.resources.color.colorBlackMain,
                ),
              ),
            ),
          ),

          // SizedBox(height: 16),
        ],
      ),
    );
  }
}
