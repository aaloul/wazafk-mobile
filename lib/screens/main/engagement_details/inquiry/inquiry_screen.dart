import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../components/engagement_common.dart';
import 'components/edit_dates_sheet.dart';

/// Full-screen inquiry compose form (design p58) — replaces the old negotiation
/// bottom sheet. Reuses the controller's negotiation fields + submitNegotiation.
class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final controller = Get.find<EngagementDetailsController>();

  @override
  void initState() {
    super.initState();
    // Pre-fill the requested dates with the engagement's current dates so the
    // inquiry can be sent even when the user only changes the price.
    final engagement = controller.engagement.value;
    if (controller.negotiationRangeStart.value == null) {
      controller.negotiationRangeStart.value = engagement?.startDatetime;
    }
    if (controller.negotiationRangeEnd.value == null) {
      controller.negotiationRangeEnd.value = engagement?.expiryDatetime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = Resources.of(context).strings;
    final engagement = controller.engagement.value;

    final isHourly =
        controller.isService.value && controller.service.value?.pricingType == 'U';
    final budget = controller.isService.value && isHourly
        ? engagement?.unitPrice
        : engagement?.totalPrice;
    final amountSuffix = isHourly ? strings.perHour : strings.perJob;

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            EngagementCenterAppBar(title: strings.inquiry),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: EngagementSectionCard(
                  title: strings.yourInquiry,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Client budget chip
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: PrimaryText(
                          text: '${strings.clientsBudget}: \$${budget ?? '-'}',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Amount request
                      PrimaryText(
                        text: strings.amountRequest,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorGrey26,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: context.resources.color.colorWhite,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: context.resources.color.colorGrey2,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller:
                                    controller.negotiationPriceController,
                                keyboardType: const TextInputType
                                    .numberWithOptions(decimal: true),
                                cursorColor:
                                    context.resources.color.colorPrimary,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.resources.color.colorGrey,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  hintText: strings.amountInUsd,
                                  hintStyle: TextStyle(
                                    color:
                                        context.resources.color.colorGrey13,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          PrimaryText(
                            text: amountSuffix,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            textColor: context.resources.color.colorBlack,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Requested dates (editable)
                      PrimaryText(
                        text: strings.requestDifferentDatesIfNeeded,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        textColor: context.resources.color.colorGrey,
                      ),
                      const SizedBox(height: 8),
                      _DatesField(controller: controller),
                      const SizedBox(height: 8),

                      // Message
                      MultilineLabeledTextField(
                        controller: controller.negotiationMessageController,
                        label: strings.message,
                        hint: strings.enterMessageToEmployerHere,
                        height: 120,
                        margin: 0,
                        labelFontSize: 14,
                        labelFontWeight: FontWeight.w600,
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.resources.color.colorWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Obx(
                () => controller.isNegotiating.value
                    ? Center(child: ProgressBar())
                    : PrimaryButton(
                        title: strings.sendInquiry,
                        height: 56,
                        borderRadius: 14,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        onPressed: controller.submitNegotiation,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatesField extends StatelessWidget {
  const _DatesField({required this.controller});

  final EngagementDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(
        const EditDatesSheet(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.resources.color.colorGrey2,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppIcons.calendar,
                width: 18, color: context.resources.color.colorPrimary),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                final start = controller.negotiationRangeStart.value;
                final end = controller.negotiationRangeEnd.value;
                final dates = <String>[
                  if (start != null) DateFormat('dd MMMM yyyy').format(start),
                  if (end != null) DateFormat('dd MMMM yyyy').format(end),
                ];
                if (dates.isEmpty) {
                  return PrimaryText(
                    text: Resources.of(context).strings.selectDateRange,
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey13,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: dates
                      .map(
                        (d) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: PrimaryText(
                            text: '•  $d',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textColor: context.resources.color.colorBlack,
                          ),
                        ),
                      )
                      .toList(),
                );
              }),
            ),
            Image.asset(AppIcons.edit,
                width: 18, color: context.resources.color.colorPrimary),
          ],
        ),
      ),
    );
  }
}
