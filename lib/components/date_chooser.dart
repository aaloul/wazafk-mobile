import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppDimentions.dart';
import '../utils/res/AppIcons.dart';
import '../utils/res/AppTheme.dart';
import 'dialog/dialog_helper.dart';

class DateChooser extends StatelessWidget {
  DateChooser({
    super.key,
    required this.label,
    required this.text,
    required this.onSelectDate,
    this.icon,
    this.marginVertical,
    this.labelFontWeight,
    required this.isMandatory,
    this.enabled,
  });

  final String label;
  final bool isMandatory;
  final bool? enabled;
  final String text;
  final FontWeight? labelFontWeight;
  String? icon;
  final Function onSelectDate;
  final double? marginVertical;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DialogHelper.showDatePopup(context, (date) {
          onSelectDate(date);
          print(date);
        });
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: marginVertical ?? 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PrimaryText(
                  text: label,
                  textColor: context.resources.color.colorGrey3,
                  fontWeight: labelFontWeight ?? FontWeight.w500,
                  fontSize: 15,
                ),
                const SizedBox(width: 4),
                if (isMandatory)
                  PrimaryText(
                    text: '*',
                    textColor: context.resources.color.colorGrey3,
                    fontWeight: labelFontWeight ?? FontWeight.w500,
                    fontSize: AppThemeValues.textSize17,
                  ),
              ],
            ),
            if (label.isNotEmpty) const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: AppDimensions.textFieldHeight,
              decoration: BoxDecoration(
                color: enabled ?? true
                    ? context.resources.color.colorWhite
                    : context.resources.color.colorWhite,
                border: Border.all(
                  width: 1,
                  color: enabled ?? true
                      ? context.resources.color.colorGrey2
                      : context.resources.color.colorGrey2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  if (icon != null) Image.asset(icon.toString(), height: 30),
                  if (icon != null) const SizedBox(width: 5),
                  Expanded(
                    child: PrimaryText(
                      text: text,
                      textColor: context.resources.color.colorGrey,
                      fontWeight: labelFontWeight ?? FontWeight.w400,
                      fontSize: AppThemeValues.textSize16,
                    ),
                  ),
                  Image.asset(AppIcons.calendar, width: 24),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            SizedBox(height: marginVertical ?? 6),
          ],
        ),
      ),
    );
  }
}
