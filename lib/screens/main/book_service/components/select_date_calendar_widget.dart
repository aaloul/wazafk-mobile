import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_text.dart';
import '../book_service_controller.dart';

class SelectDateCalendarWidget extends StatelessWidget {
  SelectDateCalendarWidget({super.key});

  final controller = Get.put(BookServiceController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar
          Obx(
            () => TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: controller.focusedDay.value,
              rangeStartDay: controller.rangeStart.value,
              rangeEndDay: controller.rangeEnd.value,
              rangeSelectionMode: controller.rangeSelectionMode.value,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableGestures: AvailableGestures.horizontalSwipe,
              onDaySelected: controller.onDaySelected,
              onRangeSelected: controller.onRangeSelected,
              onPageChanged: (focusedDay) {
                controller.focusedDay.value = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: context.resources.color.colorPrimary.withOpacity(0.3),
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
                rangeHighlightColor: context.resources.color.colorPrimary
                    .withOpacity(0.2),
                withinRangeDecoration: BoxDecoration(
                  color: context.resources.color.colorPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.resources.color.colorBlack4,
                ),
                leftChevronIcon: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.colorPrimary,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: context.resources.color.colorPrimary,
                    size: 20,
                  ),
                ),
                rightChevronIcon: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.colorPrimary,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: context.resources.color.colorPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          PrimaryText(
            text: context.resources.strings.date,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            textColor: context.resources.color.colorBlack4,
          ),
          SizedBox(height: 8),

          // Selected Date Range Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
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
                    text: controller.formatDateRange(),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorBlack4,
                  ),

                  PrimaryText(
                    text: '${controller.getTotalDays()} day(s)',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorPrimary,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8),
        ],
      ),
    );
  }
}
