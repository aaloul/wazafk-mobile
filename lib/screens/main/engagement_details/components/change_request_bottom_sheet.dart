import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../../components/outlined_button.dart';

class ChangeRequestBottomSheet extends StatelessWidget {
  const ChangeRequestBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
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
                    text: context.resources.strings.changeRequest,
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
              child: Obx(() {
                final engagement = controller.engagement.value;
                final changeRequests = engagement?.changeRequests;

                if (changeRequests == null || changeRequests.isEmpty) {
                  return Center(
                    child: PrimaryText(
                      text: context
                          .resources
                          .strings
                          .noChangeRequestDetailsAvailable,
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                // Get the latest change request
                final changeRequest = changeRequests.first;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Requester Info
                      if (changeRequest.requesterFirstName != null ||
                          changeRequest.requesterLastName != null) ...[
                        PrimaryText(
                          text: context.resources.strings.requestedBy,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textColor: context.resources.color.colorGrey,
                        ),
                        SizedBox(height: 8),
                        PrimaryText(
                          text:
                              '${changeRequest.requesterFirstName ?? ''} ${changeRequest.requesterLastName ?? ''}'
                                  .trim(),
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey,
                        ),
                        SizedBox(height: 16),
                      ],

                      // Changed Fields
                      if (changeRequest.changedFields != null &&
                          changeRequest.changedFields!.isNotEmpty) ...[
                        PrimaryText(
                          text: context.resources.strings.changedFields,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textColor: context.resources.color.colorGrey,
                        ),
                        SizedBox(height: 8),
                        PrimaryText(
                          text: changeRequest.changedFields ?? '',
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey,
                        ),
                        SizedBox(height: 16),
                      ],

                      // Message
                      if (changeRequest.message != null &&
                          changeRequest.message!.isNotEmpty) ...[
                        PrimaryText(
                          text: context.resources.strings.message,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textColor: context.resources.color.colorGrey,
                        ),
                        SizedBox(height: 8),
                        PrimaryText(
                          text: changeRequest.message!,
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey,
                        ),
                        SizedBox(height: 16),
                      ],

                      // Unit Price
                      if (changeRequest.unitPrice != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text:
                                        context.resources.strings.currentPrice,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: '\$${engagement?.unitPrice ?? 'N/A'}',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: context.resources.color.colorGrey7,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context.resources.strings.newPrice,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: '\$${changeRequest.unitPrice}',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],

                      // Total Price
                      if (changeRequest.totalPrice != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text:
                                        context.resources.strings.currentTotal,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text:
                                        '\$${engagement?.totalPrice ?? 'N/A'}',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: context.resources.color.colorGrey7,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context.resources.strings.newTotal,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: '\$${changeRequest.totalPrice}',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],

                      // Estimated Hours
                      if (changeRequest.estimatedHours != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text:
                                        context.resources.strings.currentHours,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text:
                                        '${engagement?.estimatedHours ?? 'N/A'} hrs',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: context.resources.color.colorGrey7,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context.resources.strings.newHours,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: '${changeRequest.estimatedHours} hrs',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],

                      // Start Date
                      if (changeRequest.startDatetime != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context
                                        .resources
                                        .strings
                                        .currentStartDate,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: engagement?.startDatetime != null
                                        ? DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(engagement!.startDatetime!)
                                        : 'N/A',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: context.resources.color.colorGrey7,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text:
                                        context.resources.strings.newStartDate,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(changeRequest.startDatetime!),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],

                      // Expiry Date
                      if (changeRequest.expiryDatetime != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context
                                        .resources
                                        .strings
                                        .currentDueDate,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: engagement?.expiryDatetime != null
                                        ? DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(engagement!.expiryDatetime!)
                                        : 'N/A',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: context.resources.color.colorGrey7,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context.resources.strings.newDueDate,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(changeRequest.expiryDatetime!),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],

                      // Created At
                      if (changeRequest.createdAt != null) ...[
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: context.resources.color.colorGrey.withOpacity(
                            .25,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8),
                        ),
                        PrimaryText(
                          text:
                              'Requested on ${DateFormat('MMM dd, yyyy - hh:mm a').format(changeRequest.createdAt!)}',
                          fontSize: 12,
                          textColor: context.resources.color.colorGrey7,
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),

            // Bottom Buttons
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
              child: Column(
                children: [
                  Obx(() {
                    if (controller.isAcceptingChangeRequest.value) {
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
                      title: Resources.of(context).strings.acceptChange,
                      onPressed: controller.acceptChangeRequest,
                    );
                  }),

                  SizedBox(height: 12),

                  Obx(() {
                    if (controller.isRejectingChangeRequest.value) {
                      return Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.resources.color.colorRed,
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

                    return PrimaryOutlinedButton(
                      title: Resources.of(context).strings.declineChange,
                      onPressed: controller.rejectChangeRequest,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
