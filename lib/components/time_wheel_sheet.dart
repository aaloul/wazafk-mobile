import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Wheel-style time picker sheet (hour / minute / AM-PM) with Save & Cancel —
/// used by the job start time and the service working hours.
Future<TimeOfDay?> showTimeWheelSheet(
  BuildContext context, {
  TimeOfDay? initial,
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final current = initial ?? TimeOfDay.now();
      bool isPM = current.period == DayPeriod.pm;
      int selectedHour = current.hourOfPeriod == 0 ? 12 : current.hourOfPeriod;
      int selectedMinute = current.minute;
      final colors = context.resources.color;

      return StatefulBuilder(
        builder: (builderContext, setState) {
          Widget wheel({
            required double width,
            required int count,
            required int initialItem,
            required ValueChanged<int> onChanged,
            required String Function(int) label,
            required bool Function(int) isSelected,
            double fontSize = 20,
          }) {
            return SizedBox(
              width: width,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 40,
                perspective: 0.005,
                diameterRatio: 1.2,
                physics: const FixedExtentScrollPhysics(),
                controller: FixedExtentScrollController(
                  initialItem: initialItem,
                ),
                onSelectedItemChanged: onChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: count,
                  builder: (_, i) => Center(
                    child: PrimaryText(
                      text: label(i),
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      textColor: isSelected(i)
                          ? colors.colorBlack4
                          : colors.colorGrey,
                    ),
                  ),
                ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: colors.colorWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            // Keeps the buttons clear of the system navigation bar.
            child: SafeArea(
              top: false,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: PrimaryText(
                      text: context.resources.strings.setTime,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorBlack4,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          wheel(
                            width: 70,
                            count: 12,
                            initialItem: selectedHour - 1,
                            onChanged: (i) =>
                                setState(() => selectedHour = i + 1),
                            label: (i) => (i + 1).toString().padLeft(2, '0'),
                            isSelected: (i) => selectedHour == i + 1,
                          ),
                          PrimaryText(
                            text: ':',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            textColor: colors.colorBlack4,
                          ),
                          wheel(
                            width: 70,
                            count: 60,
                            initialItem: selectedMinute,
                            onChanged: (i) => setState(() => selectedMinute = i),
                            label: (i) => i.toString().padLeft(2, '0'),
                            isSelected: (i) => selectedMinute == i,
                          ),
                          const SizedBox(width: 12),
                          wheel(
                            width: 60,
                            count: 2,
                            initialItem: isPM ? 1 : 0,
                            onChanged: (i) => setState(() => isPM = i == 1),
                            label: (i) => i == 0 ? 'AM' : 'PM',
                            isSelected: (i) =>
                                (i == 0 && !isPM) || (i == 1 && isPM),
                            fontSize: 18,
                          ),
                        ],
                      ),
                      IgnorePointer(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(height: 1, color: colors.colorGrey25),
                            const SizedBox(height: 38),
                            Container(height: 1, color: colors.colorGrey25),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final hour24 = selectedHour == 12
                                ? (isPM ? 12 : 0)
                                : (isPM ? selectedHour + 12 : selectedHour);
                            Navigator.pop(
                              sheetContext,
                              TimeOfDay(hour: hour24, minute: selectedMinute),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.colorPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: PrimaryText(
                            text: context.resources.strings.save,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: colors.colorWhite,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: colors.colorGrey25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: PrimaryText(
                            text: context.resources.strings.cancel,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: colors.colorGrey,
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
