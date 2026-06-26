import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'calendar_controller.dart';
import 'components/schedule_engagement_card.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalendarController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.calendar),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: ProgressBar());
                }
                return RefreshIndicator(
                  onRefresh: () => controller.fetchEngagements(isRefresh: true),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      Obx(() => controller.isFetching.value
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Center(child: ProgressBar(width: 24)),
                            )
                          : const SizedBox.shrink()),
                      _CalendarCard(controller: controller),
                      const SizedBox(height: 20),
                      _ScheduleSection(controller: controller),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({required this.controller});

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Obx(() {
      final month = controller.focusedMonth.value;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.colorGrey15, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavArrow(
                  isNext: false,
                  onTap: controller.goToPreviousMonth,
                ),
                Expanded(
                  child: PrimaryText(
                    text: DateFormat('MMMM yyyy').format(month),
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: colors.colorBlack,
                  ),
                ),
                _NavArrow(
                  isNext: true,
                  onTap: controller.goToNextMonth,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _WeekdayHeader(),
            const SizedBox(height: 8),
            _MonthGrid(controller: controller),
          ],
        ),
      );
    });
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.isNext, required this.onTap});

  final bool isNext;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.colorPrimary, width: 1.5),
        ),
        child: RotatedBox(
          quarterTurns: isNext ? 0 : 2,
          child: Image.asset(
            AppIcons.arrowRight2,
            width: 14,
            color: colors.colorPrimary,
          ),
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  static const _labels = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Row(
      children: List.generate(7, (i) {
        final isWeekend = i == 0 || i == 6;
        return Expanded(
          child: Center(
            child: PrimaryText(
              text: _labels[i],
              fontSize: 11,
              fontWeight: FontWeight.w600,
              textColor: isWeekend ? colors.colorGrey10 : colors.colorGrey16,
            ),
          ),
        );
      }),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({required this.controller});

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final month = controller.focusedMonth.value;
      final selected = controller.selectedDate.value;
      final firstOfMonth = DateTime(month.year, month.month, 1);
      // Sunday-first grid: DateTime weekday is Mon=1..Sun=7.
      final leadingBlanks = firstOfMonth.weekday % 7;
      final gridStart = firstOfMonth.subtract(Duration(days: leadingBlanks));

      return Column(
        children: List.generate(6, (week) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: List.generate(7, (dow) {
                final day = gridStart.add(Duration(days: week * 7 + dow));
                final inMonth = day.month == month.month;
                final isSelected = day.year == selected.year &&
                    day.month == selected.month &&
                    day.day == selected.day;
                final taskCount =
                    inMonth ? controller.engagementCountForDay(day) : 0;
                return Expanded(
                  child: _DayCell(
                    day: day,
                    inMonth: inMonth,
                    isSelected: isSelected,
                    taskCount: taskCount,
                    onTap: inMonth ? () => controller.selectDate(day) : null,
                  ),
                );
              }),
            ),
          );
        }),
      );
    });
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.isSelected,
    required this.taskCount,
    required this.onTap,
  });

  final DateTime day;
  final bool inMonth;
  final bool isSelected;
  final int taskCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final isWeekend = day.weekday == DateTime.saturday ||
        day.weekday == DateTime.sunday;
    final Color textColor = isSelected
        ? colors.colorWhite
        : !inMonth
            ? colors.colorGrey10 // other-month: faint
            : isWeekend
                ? colors.colorGrey27 // weekend: de-emphasized
                : colors.colorBlack; // weekday
    final dotColor = isSelected ? colors.colorWhite : colors.colorPrimary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        child: Container(
          width: 38,
          decoration: BoxDecoration(
            color: isSelected ? colors.colorPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryText(
                text: '${day.day}',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                textColor: textColor,
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 4,
                child: taskCount > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          taskCount > 3 ? 3 : taskCount,
                          (_) => Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleSection extends StatelessWidget {
  const _ScheduleSection({required this.controller});

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Obx(() {
      final selected = controller.selectedDate.value;
      final dayTasks = controller.engagementsForDay(selected);
      final headerText = controller.isSelectedToday
          ? strings.todaysSchedule
          : DateFormat('d MMMM yyyy').format(selected);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: headerText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const SizedBox(height: 12),
          if (dayTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: PrimaryText(
                  text: strings.noScheduleForDay,
                  fontSize: 14,
                  textColor: colors.colorGrey,
                ),
              ),
            )
          else
            ...dayTasks.map((e) => ScheduleEngagementCard(engagement: e)),
        ],
      );
    });
  }
}
