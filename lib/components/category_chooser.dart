import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppTheme.dart';

class CategoryChooser extends StatelessWidget {
  CategoryChooser({
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
    this.enabled,
  });

  final String label;
  final String? appendText;
  final Category? selected;
  final bool isMandatory;
  final bool? enabled;
  final String text;
  final FontWeight? labelFontWeight;
  String? icon;
  final Function(Category?) onSelect;
  final bool withArrow;
  final List<Category> list;

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
                  textColor: context.resources.color.colorGrey26,
                  fontWeight: labelFontWeight ?? FontWeight.w500,
                  fontSize: 14,
                ),
                const SizedBox(width: 4),
                if (isMandatory)
                  PrimaryText(
                    text: '*',
                    textColor: context.resources.color.colorGrey26,
                    fontWeight: labelFontWeight ?? FontWeight.w500,
                    fontSize: 14,
                  ),
              ],
            ),
          if (label.isNotEmpty) const SizedBox(height: 8),
          IgnorePointer(
            ignoring: !(enabled ?? true),
            child: CustomDropdown<Category>(
              hintText: text,
              items: list,
              closedHeaderPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              decoration: CustomDropdownDecoration(
                listItemStyle: TextStyle(
                  color: context.resources.color.colorPrimary,
                ),
                closedFillColor: Colors.white,
                expandedFillColor: Colors.white,
                headerStyle: TextStyle(
                  color: context.resources.color.colorPrimary,
                  fontWeight: labelFontWeight ?? FontWeight.w400,
                  fontSize: AppThemeValues.textSize16,
                ),
                closedSuffixIcon: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.colorPrimary,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.resources.color.colorPrimary,
                    size: 14,
                  ),
                ),
                expandedSuffixIcon: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.colorPrimary,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: context.resources.color.colorPrimary,
                    size: 20,
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
              initialItem: () {
                final selectedItem = selected;
                if (selectedItem != null && list.isNotEmpty) {
                  try {
                    return list.firstWhere(
                      (c) => c.hashcode == selectedItem.hashcode,
                    );
                  } catch (e) {
                    return null;
                  }
                }
                return null;
              }(),
              onChanged: (value) {
                onSelect(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
