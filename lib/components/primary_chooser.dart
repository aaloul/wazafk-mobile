import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppIcons.dart';
import '../utils/res/AppTheme.dart';

class PrimaryChooser extends StatelessWidget {
  PrimaryChooser({
    super.key,
    required this.label,
    required this.text,
    required this.onSelect,
    this.icon,
    this.selected,
    this.appendText,
    this.labelFontWeight,
    required this.withArrow,
    required this.isMandatory,
    required this.list,
    required this.isMultiSelect,
    this.enabled,
  });

  final String label;
  final String? appendText;
  final String? selected;
  final bool isMandatory;
  final bool isMultiSelect;
  final bool? enabled;
  final String text;
  final FontWeight? labelFontWeight;
  String? icon;
  final Function onSelect;
  final bool withArrow;
  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
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
                    fontSize: 15,
                  ),
              ],
            ),
          if (label.isNotEmpty) const SizedBox(height: 8),
          if (!isMultiSelect)
            IgnorePointer(
              ignoring: !(enabled ?? true),
              child: CustomDropdown<String>(
                hintText: text,
                items: list,
                canCloseOutsideBounds: false,
                hideSelectedFieldWhenExpanded: false,
                excludeSelected: false,
                closedHeaderPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: CustomDropdownDecoration(
                  listItemStyle: TextStyle(
                    color: context.resources.color.colorGrey3,
                  ),
                  closedFillColor: enabled ?? true
                      ? context.resources.color.colorWhite
                      : context.resources.color.colorGrey4,
                  expandedFillColor: enabled ?? true
                      ? context.resources.color.colorWhite
                      : context.resources.color.colorGrey4,
                  headerStyle: TextStyle(
                    color: context.resources.color.colorGrey3,
                    fontWeight: labelFontWeight ?? FontWeight.w400,
                    fontSize: AppThemeValues.textSize18,
                  ),
                  closedSuffixIcon: RotatedBox(
                    quarterTurns: 1,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Image.asset(
                        AppIcons.arrowDown,
                        width: 12,
                        color: context.resources.color.colorGrey,
                      ),
                    ),
                  ),
                  expandedSuffixIcon: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      AppIcons.arrowDown,
                      width: 12,
                      color: context.resources.color.colorGrey,
                    ),
                  ),
                  closedBorder: Border.all(
                    width: 1,
                    color: enabled ?? true
                        ? context.resources.color.colorGrey2
                        : context.resources.color.colorGrey2,
                  ),
                  closedBorderRadius: BorderRadius.circular(10),
                ),
                initialItem: selected != null && selected!.isNotEmpty
                    ? selected
                    : null,
                onChanged: (value) {
                  onSelect(value);
                },
              ),
            ),
          if (isMultiSelect)
            CustomDropdown<String>.multiSelect(
              hintText: text,
              canCloseOutsideBounds: false,
              hideSelectedFieldWhenExpanded: false,
              closedHeaderPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              disabledDecoration: CustomDropdownDisabledDecoration(
                fillColor: enabled ?? true
                    ? context.resources.color.colorWhite
                    : context.resources.color.colorGrey4,
                headerStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: context.resources.color.colorGrey3,
                  fontSize: AppThemeValues.textSize18,
                ),
                suffixIcon: Image.asset(
                  AppIcons.arrowRight,
                  width: 16,
                  color: context.resources.color.colorGrey,
                ),
              ),
              decoration: CustomDropdownDecoration(
                listItemStyle: TextStyle(
                  color: context.resources.color.colorGrey3,
                ),
                closedFillColor: context.resources.color.colorWhite,
                expandedFillColor: context.resources.color.colorWhite,
                listItemDecoration: ListItemDecoration(
                  selectedIconColor: context.resources.color.colorGrey3,
                  selectedColor: context.resources.color.colorGrey2,
                  splashColor: context.resources.color.colorGrey2,
                ),
                headerStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: context.resources.color.colorGrey3,
                  fontSize: AppThemeValues.textSize18,
                ),
                closedSuffixIcon: RotatedBox(
                  quarterTurns: 2,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Image.asset(AppIcons.arrowRight, width: 12),
                  ),
                ),
                expandedSuffixIcon: RotatedBox(
                  quarterTurns: 3,
                  child: Image.asset(
                    AppIcons.arrowRight,
                    width: 12,
                    color: context.resources.color.colorGrey,
                  ),
                ),
                closedBorder: Border.all(
                  width: 1,
                  color: context.resources.color.colorGrey2,
                ),
                closedBorderRadius: BorderRadius.circular(10),
              ),
              items: list,
              initialItems: selected != null && selected!.isNotEmpty
                  ? [selected!]
                  : [],
              onListChanged: (value) {
                onSelect(value);
              },
              listValidator: (value) =>
                  value.isEmpty ? "Must not be empty" : null,
            ),
        ],
      ),
    );
  }
}
