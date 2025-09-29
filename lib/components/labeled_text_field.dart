import 'package:flutter/material.dart';
import 'package:wazafak_app/components/password_text_field.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/primary_text_field.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppTheme.dart';


class LabeledTextFiled extends StatelessWidget {
  LabeledTextFiled(
      {super.key,
      required this.label,
      required this.hint,
      required this.inputType,
      this.onTextChanged,
      this.controller,
      this.startText,
      this.startIcon,
      this.height,
      this.bottomDesc,
      this.maxLength,
      this.labelFontWeight,
      this.borderColor,
      this.maxLines,
      this.focusNode,
      this.allowDecimals,
      this.textInputAction,
      this.isOptional,
      required this.isPassword,
      required this.isMandatory,
      this.enabled});

  TextInputAction? textInputAction;

  final bool? isPassword;
  final bool isMandatory;
  final bool? enabled;
  final bool? allowDecimals;
  final bool? isOptional;
  final String label;
  final FontWeight? labelFontWeight;
  final String hint;
  double? height;
  int? maxLines;
  int? maxLength;
  Color? borderColor;

  String? startText = '';
  String? startIcon = '';
  String? bottomDesc = '';
  final TextInputType inputType;
  Function? onTextChanged;
  TextEditingController? controller ;
  FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PrimaryText(
                text: label,
                textColor: context.resources.color.colorGrey,
                fontWeight: labelFontWeight ?? FontWeight.w400,
                fontSize: 15,
              ),
              const SizedBox(
                width: 1,
              ),
              if (isMandatory)
                PrimaryText(
                  text: '*',
                  textColor: context.resources.color.colorGrey,
                  fontWeight: labelFontWeight ?? FontWeight.w500,
                  fontSize: 15
                ),
              if (isOptional ?? false)
                Flexible(
                  child: PrimaryText(
                    text:'(optional)',
                    textColor: context.resources.color.colorGrey,
                    fontWeight: labelFontWeight ?? FontWeight.w400,
                    maxLines: 1,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          isPassword ?? false
              ? PasswordTextField(
                  hint: hint,
                  inputType: inputType,
                  controller: controller,
                  onTextChanged: onTextChanged,
                  startIcon: startIcon,
                )
              :  PrimaryTextField(
                      hint: hint,
                      height: height,
                      startIcon: startIcon,
                      startText: startText,
                      borderColor: borderColor,
                      maxLines: maxLines,
                      maxLength: maxLength,
                      inputType: inputType,
                      controller: controller,
                      textInputAction: textInputAction,
                      enabled: enabled,
                      onTextChanged: onTextChanged),
          if (bottomDesc != null)
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                bottomDesc.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppThemeValues.textSize15,
                    color: context.resources.color.colorGrey),
              ),
            )
        ],
      ),
    );
  }
}
