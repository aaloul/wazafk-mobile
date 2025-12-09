import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class DisputeBottomSheet extends StatelessWidget {
  const DisputeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.resources.color.colorGrey15,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryText(
                    text: 'Submit Dispute',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorGrey,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: context.resources.color.colorGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text:
                          'Please describe the reason for disputing this engagement',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: context.resources.color.colorGrey19,
                    ),

                    SizedBox(height: 16),

                    // Reason Description Field
                    MultilineLabeledTextField(
                      controller: controller.disputeReasonController,
                      label: 'Reason',
                      hint: 'Enter the reason for dispute...',
                      maxLines: 20,
                      height: 200,
                      labelFontSize: 14,
                      margin: 0,
                      labelFontWeight: FontWeight.w500,
                      inputType: TextInputType.text,
                      isPassword: false,
                      isMandatory: true,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: context.resources.color.colorGrey15,
                    width: 1,
                  ),
                ),
              ),
              child: Obx(
                () => controller.isSubmittingDispute.value
                    ? Center(child: ProgressBar())
                    : PrimaryButton(
                        title: 'Submit Dispute',
                        onPressed: controller.submitDispute,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
