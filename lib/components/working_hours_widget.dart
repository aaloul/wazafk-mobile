import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class WorkingHoursWidget extends StatelessWidget {
  const WorkingHoursWidget({
    super.key,
    required this.availability,
  });

  final List<Availability> availability;

  // Day order mapping
  static const Map<String, int> _dayOrder = {
    'monday': 1,
    'mon': 1,
    'tuesday': 2,
    'tue': 2,
    'wednesday': 3,
    'wed': 3,
    'thursday': 4,
    'thu': 4,
    'friday': 5,
    'fri': 5,
    'saturday': 6,
    'sat': 6,
    'sunday': 7,
    'sun': 7,
  };

  // Day key mapping (maps abbreviated and full names to a day key)
  static const Map<String, String> _dayKeys = {
    'monday': 'monday',
    'mon': 'monday',
    'tuesday': 'tuesday',
    'tue': 'tuesday',
    'wednesday': 'wednesday',
    'wed': 'wednesday',
    'thursday': 'thursday',
    'thu': 'thursday',
    'friday': 'friday',
    'fri': 'friday',
    'saturday': 'saturday',
    'sat': 'saturday',
    'sunday': 'sunday',
    'sun': 'sunday',
  };

  @override
  Widget build(BuildContext context) {
    if (availability.isEmpty) {
      return SizedBox.shrink();
    }

    // Sort availability by day order
    final sortedAvailability = _sortAvailability(availability);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: Resources.of(context).strings.workingDays,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            textColor: context.resources.color.colorGrey,
          ),
          SizedBox(height: 12),
          ...sortedAvailability.map((day) => _buildDayRow(context, day)).toList(),
        ],
      ),
    );
  }

  List<Availability> _sortAvailability(List<Availability> availability) {
    final sorted = List<Availability>.from(availability);
    sorted.sort((a, b) {
      final dayA = a.day?.toLowerCase() ?? '';
      final dayB = b.day?.toLowerCase() ?? '';
      final orderA = _dayOrder[dayA] ?? 999;
      final orderB = _dayOrder[dayB] ?? 999;
      return orderA.compareTo(orderB);
    });
    return sorted;
  }

  String _getFullDayName(BuildContext context, String? day) {
    if (day == null || day.isEmpty) return '';
    final dayLower = day.toLowerCase();
    final dayKey = _dayKeys[dayLower];

    if (dayKey == null) return day;

    final strings = Resources.of(context).strings;

    switch (dayKey) {
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

  Widget _buildDayRow(BuildContext context, Availability day) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Day name
          Expanded(
            flex: 2,
            child: PrimaryText(
              text: _getFullDayName(context, day.day),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: context.resources.color.colorGrey,
            ),
          ),
          // Time range
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.resources.color.colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: PrimaryText(
                text: '${_formatTime(day.startTime)} - ${_formatTime(day.endTime)}',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textColor: context.resources.color.colorPrimary,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '';

    // Handle different time formats
    // If time is already in HH:MM format, return as is
    if (time.contains(':')) {
      final parts = time.split(':');
      if (parts.length >= 2) {
        try {
          int hour = int.parse(parts[0]);
          int minute = int.parse(parts[1]);

          // Convert to 12-hour format
          String period = hour >= 12 ? 'PM' : 'AM';
          hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

          return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
        } catch (e) {
          return time;
        }
      }
    }

    return time;
  }
}
