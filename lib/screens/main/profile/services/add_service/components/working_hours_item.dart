import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_switch.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/WorkingHoursModel.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class WorkingHoursItem extends StatelessWidget {
  final WorkingHoursDay workingDay;
  final int index;
  final Function(bool) onToggle;
  final Function(String) onStartTimeSelect;
  final Function(String) onEndTimeSelect;

  const WorkingHoursItem({
    super.key,
    required this.workingDay,
    required this.index,
    required this.onToggle,
    required this.onStartTimeSelect,
    required this.onEndTimeSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: workingDay.isEnabled ? HexColor("#E7F3EE") : HexColor("#EDEDED"),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor("#00AEC81A")),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 12),

              Expanded(
                child: PrimaryText(
                  text: workingDay.day,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  textColor: context.resources.color.colorPrimary,
                ),
              ),

              Row(
                children: [
                  _buildTimeSelector(
                    context,
                    'Start Time',
                    workingDay.startTime,
                    onStartTimeSelect,
                  ),

                  Container(
                    width: 6,
                    height: 1,
                    color: context.resources.color.colorGrey8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                  ),

                  _buildTimeSelector(
                    context,
                    'End Time',
                    workingDay.endTime,
                    onEndTimeSelect,
                  ),
                ],
              ),

              SizedBox(width: 4),

              PrimarySwitch(
                checked: workingDay.isEnabled,
                thumbColorActive: context.resources.color.colorWhite,
                thumbColorNotActive: context.resources.color.colorWhite,
                trackColor: context.resources.color.colorGrey8,
                activeTrackColor: context.resources.color.colorPrimary,
                activeColor: context.resources.color.colorPrimary,
                onChange: (value) => onToggle(value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(
    BuildContext context,
    String label,
    String selectedTime,
    Function(String) onSelect,
  ) {
    return GestureDetector(
      onTap: () {
        _showCompactTimePicker(context, selectedTime, onSelect);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: context.resources.color.colorGrey8),
        ),
        child: PrimaryText(
          text: _formatTimeTo12Hour(selectedTime),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          textColor: context.resources.color.colorGrey8,
        ),
      ),
    );
  }

  String _formatTimeTo12Hour(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? 'PM' : 'AM';
    int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  void _showCompactTimePicker(
    BuildContext context,
    String currentTime,
    Function(String) onSelect,
  ) {
    final timeParts = currentTime.split(':');
    int hour24 = int.parse(timeParts[0]);
    int selectedMinute = int.parse(timeParts[1]);

    // Convert to 12-hour format
    bool isPM = hour24 >= 12;
    int selectedHour = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 280,
              decoration: BoxDecoration(
                color: context.resources.color.background2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  PrimaryText(
                    text: 'Select Time',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorPrimary,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hour picker (1-12)
                        SizedBox(
                          width: 70,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(
                              initialItem: selectedHour - 1,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() => selectedHour = index + 1);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 12,
                              builder: (context, index) {
                                final hour = index + 1;
                                return Center(
                                  child: PrimaryText(
                                    text: hour.toString().padLeft(2, '0'),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    textColor: selectedHour == hour
                                        ? context.resources.color.colorPrimary
                                        : context.resources.color.colorGrey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        PrimaryText(
                          text: ':',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorPrimary,
                        ),
                        // Minute picker
                        SizedBox(
                          width: 70,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(
                              initialItem: selectedMinute ~/ 15,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() => selectedMinute = index * 15);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 4,
                              builder: (context, index) {
                                final minute = index * 15;
                                return Center(
                                  child: PrimaryText(
                                    text: minute.toString().padLeft(2, '0'),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    textColor: selectedMinute == minute
                                        ? context.resources.color.colorPrimary
                                        : context.resources.color.colorGrey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        // AM/PM picker
                        SizedBox(
                          width: 60,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(
                              initialItem: isPM ? 1 : 0,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() => isPM = index == 1);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 2,
                              builder: (context, index) {
                                final period = index == 0 ? 'AM' : 'PM';
                                final isSelected =
                                    (index == 0 && !isPM) ||
                                    (index == 1 && isPM);
                                return Center(
                                  child: PrimaryText(
                                    text: period,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    textColor: isSelected
                                        ? context.resources.color.colorPrimary
                                        : context.resources.color.colorGrey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: PrimaryText(
                              text: 'Cancel',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              textColor: context.resources.color.colorGrey,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Convert back to 24-hour format
                              int hour24;
                              if (selectedHour == 12) {
                                hour24 = isPM ? 12 : 0;
                              } else {
                                hour24 = isPM
                                    ? selectedHour + 12
                                    : selectedHour;
                              }

                              final timeString =
                                  '${hour24.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
                              onSelect(timeString);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  context.resources.color.colorPrimary,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: PrimaryText(
                              text: 'Confirm',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              textColor: context.resources.color.colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
