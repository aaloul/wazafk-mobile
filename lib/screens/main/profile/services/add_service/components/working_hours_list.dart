import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/time_wheel_sheet.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../add_service_controller.dart';

/// Inline "Working Hours" editor (design p112 / p107): a checkbox per day and,
/// for the picked days, the start – end time pills.
class WorkingHoursList extends StatelessWidget {
  const WorkingHoursList({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddServiceController>();
    final colors = context.resources.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: context.resources.strings.workingHours,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: colors.colorGrey26,
        ),
        const SizedBox(height: 14),
        Obx(() {
          final days = controller.workingHours;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < days.length; index++) ...[
                _DayRow(
                  index: index,
                  name: _localizedDay(context, days[index].day),
                  isEnabled: days[index].isEnabled,
                  startTime: days[index].startTime,
                  endTime: days[index].endTime,
                  enabled: enabled,
                ),
                if (index != days.length - 1)
                  days[index].isEnabled
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Container(height: 1, color: colors.colorGrey25),
                        )
                      : const SizedBox(height: 14),
              ],
            ],
          );
        }),
      ],
    );
  }

  static String _localizedDay(BuildContext context, String day) {
    final strings = context.resources.strings;
    switch (day.toLowerCase()) {
      case 'monday':
        return strings.monday;
      case 'tuesday':
        return strings.tuesday;
      case 'wednesday':
        return strings.wednesday;
      case 'thursday':
        return strings.thursday;
      case 'friday':
        return strings.friday;
      case 'saturday':
        return strings.saturday;
      case 'sunday':
        return strings.sunday;
      default:
        return day;
    }
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.index,
    required this.name,
    required this.isEnabled,
    required this.startTime,
    required this.endTime,
    required this.enabled,
  });

  final int index;
  final String name;
  final bool isEnabled;
  final String startTime;
  final String endTime;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddServiceController>();
    final colors = context.resources.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled
              ? () => controller.toggleDayEnabled(index, !isEnabled)
              : null,
          child: Row(
            children: [
              Image.asset(
                isEnabled ? AppIcons.checkboxChecked : AppIcons.checkboxUnchecked,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
              PrimaryText(
                text: name,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                textColor: colors.colorBlack4,
              ),
            ],
          ),
        ),
        if (isEnabled) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              _TimePill(
                time: startTime,
                enabled: enabled,
                onPicked: (value) => controller.updateStartTime(index, value),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: PrimaryText(
                  text: '-',
                  fontSize: 14,
                  textColor: colors.colorGrey26,
                ),
              ),
              _TimePill(
                time: endTime,
                enabled: enabled,
                onPicked: (value) => controller.updateEndTime(index, value),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// "09 : 30 AM" pill that opens the wheel picker.
class _TimePill extends StatelessWidget {
  const _TimePill({
    required this.time,
    required this.onPicked,
    required this.enabled,
  });

  final String time;
  final ValueChanged<String> onPicked;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;

    return GestureDetector(
      onTap: enabled
          ? () async {
              final picked = await showTimeWheelSheet(
                context,
                initial: _parse(time),
              );
              if (picked != null) {
                onPicked(
                  '${picked.hour.toString().padLeft(2, '0')}:'
                  '${picked.minute.toString().padLeft(2, '0')}',
                );
              }
            }
          : null,
      child: Container(
        width: 118,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.colorGrey25),
        ),
        child: PrimaryText(
          text: _format(time),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: colors.colorGrey26,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// "17:30" -> "05 : 30 PM"
  static String _format(String time24) {
    final parsed = _parse(time24);
    if (parsed == null) return time24;
    final hour12 = parsed.hourOfPeriod == 0 ? 12 : parsed.hourOfPeriod;
    final period = parsed.period == DayPeriod.pm ? 'PM' : 'AM';
    return '${hour12.toString().padLeft(2, '0')} : '
        '${parsed.minute.toString().padLeft(2, '0')} $period';
  }

  static TimeOfDay? _parse(String time24) {
    final parts = time24.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }
}
