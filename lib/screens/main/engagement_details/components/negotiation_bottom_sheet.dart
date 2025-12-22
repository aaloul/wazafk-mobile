import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class NegotiationBottomSheet extends StatelessWidget {
  const NegotiationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
                    text: Resources.of(context).strings.negotiateTerms,
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
                    // Price Field
                    LabeledTextFiled(
                      controller: controller.negotiationPriceController,
                      label: Resources.of(context).strings.price,
                      hint: Resources.of(context).strings.enterYourPrice,
                      inputType: TextInputType.numberWithOptions(decimal: true),
                      isPassword: false,
                      isMandatory: true,
                      labelFontWeight: FontWeight.w500,
                    ),

                    SizedBox(height: 16),

                    // Estimated Hours Field
                    LabeledTextFiled(
                      controller: controller.negotiationHoursController,
                      label: Resources.of(context).strings.estimatedHours,
                      hint: Resources.of(context).strings.enterEstimatedHours,
                      inputType: TextInputType.number,
                      isPassword: false,
                      isMandatory: true,
                      labelFontWeight: FontWeight.w500,
                    ),

                    SizedBox(height: 20),

                    // Calendar Section
                    PrimaryText(
                      text: Resources.of(context).strings.selectDateRange,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),

                    SizedBox(height: 12),

                    // Calendar
                    Obx(
                      () => TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(Duration(days: 365)),
                        focusedDay: controller.negotiationFocusedDay.value,
                        rangeStartDay: controller.negotiationRangeStart.value,
                        rangeEndDay: controller.negotiationRangeEnd.value,
                        rangeSelectionMode:
                            controller.negotiationRangeSelectionMode.value,
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        availableGestures: AvailableGestures.horizontalSwipe,
                        onDaySelected: controller.onNegotiationDaySelected,
                        onRangeSelected: controller.onNegotiationRangeSelected,
                        onPageChanged: (focusedDay) {
                          controller.negotiationFocusedDay.value = focusedDay;
                        },
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: context.resources.color.colorPrimary
                                .withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: context.resources.color.colorPrimary,
                            shape: BoxShape.circle,
                          ),
                          rangeStartDecoration: BoxDecoration(
                            color: context.resources.color.colorPrimary,
                            shape: BoxShape.circle,
                          ),
                          rangeEndDecoration: BoxDecoration(
                            color: context.resources.color.colorPrimary,
                            shape: BoxShape.circle,
                          ),
                          rangeHighlightColor: context
                              .resources
                              .color
                              .colorPrimary
                              .withOpacity(0.2),
                          withinRangeDecoration: BoxDecoration(
                            color: context.resources.color.colorPrimary
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.resources.color.colorGrey,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Selected Date Range Display
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.resources.color.background2,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.resources.color.colorGrey2,
                          width: 1,
                        ),
                      ),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryText(
                              text: controller.formatNegotiationDateRange(),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey19,
                            ),
                            PrimaryText(
                              text:
                                  '${controller.getNegotiationTotalDays()} day(s)',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              textColor: context.resources.color.colorPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Message Field
                    MultilineLabeledTextField(
                      controller: controller.negotiationMessageController,
                      label: Resources.of(context).strings.message,
                      hint: Resources.of(context).strings.enterYourMessage,
                      maxLines: 20,
                      height: 120,
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
                () => controller.isNegotiating.value
                    ? Center(child: ProgressBar())
                    : PrimaryButton(
                        title: Resources.of(context).strings.submitNegotiation,
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
