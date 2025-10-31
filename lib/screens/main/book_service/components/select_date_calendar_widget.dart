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
    return Column(
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
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.resources.color.colorGrey,
              ),
            ),
          ),
        ),

        SizedBox(height: 16),

        PrimaryText(
          text: "Date",
          fontWeight: FontWeight.w900,
          fontSize: 16,
          textColor: context.resources.color.colorGrey,
        ),
        SizedBox(height: 12),

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
                  text: controller.formatDateRange(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorGrey19,
                ),

                PrimaryText(
                  text: '${controller.getTotalDays()} day(s)',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: context.resources.color.colorPrimary,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 8),
      ],
    );
  }
}
