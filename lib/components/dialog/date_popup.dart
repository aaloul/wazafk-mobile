import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class DatePopup extends StatelessWidget {
  const DatePopup({
    super.key,
    required this.onDateSelected,
    this.minDate,
    this.maxDate,
  });

  final Function onDateSelected;
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
    width: 200,
    height: 290,
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: context.resources.color.colorWhite,
      borderRadius: BorderRadius.circular(12),
    ),
    child: SfDateRangePicker(
      backgroundColor: context.resources.color.colorWhite,
      showNavigationArrow: true,
      maxDate: maxDate,
      minDate: minDate,
      monthViewSettings: DateRangePickerMonthViewSettings(
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(
            color: context.resources.color.colorGrey3.withOpacity(.6),
          ),
        ),
        weekNumberStyle: DateRangePickerWeekNumberStyle(
          textStyle: TextStyle(color: context.resources.color.colorGrey3),
        ),
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        textStyle: TextStyle(color: context.resources.color.colorGrey3),
        weekendTextStyle: TextStyle(color: context.resources.color.colorGrey3),
        trailingDatesTextStyle: TextStyle(
          color: context.resources.color.colorGrey3,
        ),
      ),
      yearCellStyle: DateRangePickerYearCellStyle(
        textStyle: TextStyle(color: context.resources.color.colorGrey3),
      ),
      selectionTextStyle: TextStyle(color: context.resources.color.colorGrey3),
      headerStyle: DateRangePickerHeaderStyle(
        backgroundColor: context.resources.color.colorWhite,
        textStyle: TextStyle(color: context.resources.color.colorGrey3),
      ),
      onSelectionChanged: (date) {
        onDateSelected(date.value);
        Navigator.pop(context);
      },
      selectionMode: DateRangePickerSelectionMode.single,
    ),
  );
}
