import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class FinishEngagementBottomSheet extends StatelessWidget {
  const FinishEngagementBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
                  text: 'Finish Engagement',
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
                    text: 'Upload Deliverables',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorGrey,
                  ),
                  SizedBox(height: 8),
                  PrimaryText(
                    text: 'Please upload the completed work deliverables',
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey7,
                  ),
                  SizedBox(height: 16),

                  // File Upload Section
                  Obx(() {
                    final hasFile = controller.deliverableFile.value != null;

                    return GestureDetector(
                      onTap: () => controller.pickDeliverableFile(context),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: hasFile
                              ? context.resources.color.colorBlue4
                              : context.resources.color.colorGrey15,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: hasFile
                                ? context.resources.color.colorPrimary
                                : context.resources.color.colorGrey18,
                            width: 2,
                          ),
                        ),
                        child: hasFile
                            ? Row(
                                children: [
                                  Icon(
                                    controller.getDeliverableFileIcon(),
                                    color: context.resources.color.colorPrimary,
                                    size: 40,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PrimaryText(
                                          text:
                                              controller
                                                  .deliverableFileName
                                                  .value ??
                                              'File selected',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                        SizedBox(height: 4),
                                        PrimaryText(
                                          text: controller
                                              .getDeliverableFileSize(),
                                          fontSize: 12,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorGrey7,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: context.resources.color.colorRed,
                                    ),
                                    onPressed: controller.removeDeliverableFile,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 48,
                                    color: context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 8),
                                  PrimaryText(
                                    text: 'Tap to upload file',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: 'PDF, DOC, DOCX, ZIP, RAR, JPG, PNG',
                                    fontSize: 12,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                ],
                              ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.resources.color.colorWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Obx(() {
              if (controller.isFinishingEngagement.value) {
                return Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: context.resources.color.colorWhite,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              }

              return PrimaryButton(
                title: 'Submit & Finish',
                onPressed: controller.finishEngagement,
              );
            }),
          ),
        ],
      ),
    );
  }
}
