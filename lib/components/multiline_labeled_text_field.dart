import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppDimentions.dart';
import '../utils/res/AppTheme.dart';
import '../utils/utils.dart';

class MultilineLabeledTextField extends StatelessWidget {
  MultilineLabeledTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.inputType,
    this.onTextChanged,
    this.controller,
    this.startText,
    this.startIcon,
    this.height,
    this.bottomDesc,
    this.labelFontWeight,
    this.maxLines,
    this.margin,
    this.labelFontSize,
    required this.isPassword,
    required this.isMandatory,
    this.enabled,
  });

  final bool isPassword;
  final bool isMandatory;
  final bool? enabled;
  final String label;
  final FontWeight? labelFontWeight;
  final String hint;
  double? height;
  double? margin;
  double? labelFontSize;
  int? maxLines;

  String? startText = '';
  String? startIcon = '';
  String? bottomDesc = '';
  final TextInputType inputType;
  Function? onTextChanged;
  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: margin ?? 8),
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
                  fontSize: labelFontSize ?? AppThemeValues.textSize18,
                ),
                const SizedBox(width: 4),
                if (isMandatory)
                  PrimaryText(
                    text: '*',
                    textColor: context.resources.color.colorGrey3,
                    fontWeight: labelFontWeight ?? FontWeight.w500,
                    fontSize: AppThemeValues.textSize16,
                  ),
              ],
            ),
          if (label.isNotEmpty) const SizedBox(height: 8),
          Container(
            height: height ?? AppDimensions.textFieldHeight,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              enabled: true,
              cursorColor: Theme.of(context).primaryColor,
              onEditingComplete: () => Utils().hideKeyboard(context),
              textAlign: TextAlign.start,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              controller: controller,
              textInputAction: TextInputAction.done,
              onChanged: (text) {},
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppThemeValues.textSize17,
                color: context.resources.color.colorGrey,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  color: context.resources.color.colorGrey13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'DM Sans Text',
                  fontSize: AppThemeValues.textSize16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
