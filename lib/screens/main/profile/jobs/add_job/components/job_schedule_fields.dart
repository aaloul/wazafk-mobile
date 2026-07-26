import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/picker_field.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/time_wheel_sheet.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../add_job_controller.dart';

/// Start date picker — unlabelled field with the "--start date --" placeholder
/// (design p185).
class JobStartDateField extends StatelessWidget {
  const JobStartDateField({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Obx(
      () => _DateField(
        hint: context.resources.strings.startDatePlaceholder,
        value: controller.selectedDate.value,
        enabled: enabled,
        sheetTitle: context.resources.strings.selectDate,
        onPicked: controller.selectDate,
      ),
    );
  }
}

/// Start time picker — unlabelled field with the "-start time-" placeholder
/// (design p185).
class JobStartTimeField extends StatelessWidget {
  const JobStartTimeField({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Obx(
      () => _TimeField(
        hint: context.resources.strings.startTimePlaceholder,
        value: controller.selectedTime.value,
        enabled: enabled,
        onPicked: controller.selectTime,
      ),
    );
  }
}

/// Expiry date — optional; the post stops accepting applications after it.
class JobExpiryDateField extends StatelessWidget {
  const JobExpiryDateField({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Obx(
      () => _DateField(
        hint: context.resources.strings.expiryDatePlaceholder,
        value: controller.selectedExpiryDate.value,
        enabled: enabled,
        sheetTitle: context.resources.strings.selectExpiryDate,
        // An expiry before the start date makes no sense.
        firstDate: controller.selectedDate.value,
        onPicked: controller.selectExpiryDate,
      ),
    );
  }
}

/// Expiry time — optional, paired with [JobExpiryDateField].
class JobExpiryTimeField extends StatelessWidget {
  const JobExpiryTimeField({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Obx(
      () => _TimeField(
        hint: context.resources.strings.expiryTimePlaceholder,
        value: controller.selectedExpiryTime.value,
        enabled: enabled,
        onPicked: controller.selectExpiryTime,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.hint,
    required this.value,
    required this.sheetTitle,
    required this.onPicked,
    this.firstDate,
    this.enabled = true,
  });

  final String hint;
  final DateTime? value;
  final String sheetTitle;
  final ValueChanged<DateTime> onPicked;
  final DateTime? firstDate;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PickerField(
      hint: hint,
      value: value != null ? DateFormat('MMM dd, yyyy').format(value!) : null,
      enabled: enabled,
      trailing: Image.asset(
        AppIcons.calendar,
        width: 20,
        color: context.resources.color.colorGrey10,
      ),
      onTap: () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final earliest = (firstDate != null && firstDate!.isAfter(now))
        ? firstDate!
        : now;
    final initial = (value != null && !value!.isBefore(earliest))
        ? value!
        : earliest;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          height: 400,
          decoration: BoxDecoration(
            color: context.resources.color.colorWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              PrimaryText(
                text: sheetTitle,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                textColor: context.resources.color.colorGrey,
              ),
              Expanded(
                // Selected day circle in the app's primary colour.
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: context.resources.color.colorPrimary,
                    ),
                  ),
                    child: CalendarDatePicker(
                    initialDate: initial,
                    firstDate: earliest,
                    lastDate: now.add(const Duration(days: 365)),
                    onDateChanged: (date) {
                      onPicked(date);
                      Navigator.pop(sheetContext);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.hint,
    required this.value,
    required this.onPicked,
    this.enabled = true,
  });

  final String hint;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onPicked;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PickerField(
      hint: hint,
      value: value?.format(context),
      enabled: enabled,
      trailing: Image.asset(
        AppIcons.clock,
        width: 20,
        color: context.resources.color.colorGrey10,
      ),
      onTap: () async {
        final picked = await showTimeWheelSheet(context, initial: value);
        if (picked != null) onPicked(picked);
      },
    );
  }
}
