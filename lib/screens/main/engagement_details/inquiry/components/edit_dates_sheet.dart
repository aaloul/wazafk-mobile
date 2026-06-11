import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

/// Date-range picker bottom sheet used by the Inquiry screen's "Dates" edit
/// pencil. Reuses the controller's negotiation range fields.
class EditDatesSheet extends StatelessWidget {
  const EditDatesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
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
                    text: Resources.of(context).strings.selectDateRange,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorGrey,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const PrimaryText(
                      text: '✕',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
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
                  onPageChanged: (focusedDay) =>
                      controller.negotiationFocusedDay.value = focusedDay,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color:
                          context.resources.color.colorPrimary.withOpacity(0.3),
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
                    rangeHighlightColor:
                        context.resources.color.colorPrimary.withOpacity(0.2),
                    withinRangeDecoration: BoxDecoration(
                      color:
                          context.resources.color.colorPrimary.withOpacity(0.1),
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PrimaryButton(
                title: Resources.of(context).strings.confirm,
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
