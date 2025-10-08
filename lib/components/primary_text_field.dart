import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/extentions.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppDimentions.dart';
import '../utils/res/AppTheme.dart';
import '../utils/utils.dart';

class PrimaryTextField extends StatelessWidget {
  PrimaryTextField({
    super.key,
    required this.hint,
    required this.inputType,
    this.onTextChanged,
    this.controller,
    this.enabled,
    this.startText,
    this.startIcon,
    this.maxLength,
    this.height,
    this.borderColor,
    this.margin,
    this.fontWeight,
    this.fontSize,
    this.maxLines,
    this.endIcon,
    this.textInputAction,
    this.endIconClick,
  });

  final String hint;
  final TextInputType inputType;
  Function? onTextChanged;
  TextEditingController? controller = TextEditingController();
  bool? enabled = true;
  String? startText = '';
  String? startIcon = '';
  String? endIcon = '';
  double? height;
  double? margin;
  double? fontSize;
  int? maxLength;
  Color? borderColor;
  FontWeight? fontWeight;
  int? maxLines;
  TextInputAction? textInputAction;
  Function? endIconClick;

  var isEmpty = true.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? AppDimensions.textFieldHeight,
        width: double.infinity,
        decoration: BoxDecoration(
            color: context.resources.color.colorWhite,
            border: Border.all(
                width: 1, color: borderColor ?? context.resources.color.colorGrey2),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: margin ?? 0,
              ),
              if (startIcon != null)
                Image.asset(
                  startIcon.toString(),
                  height: 30,
                  color: context.resources.color.colorPrimary,
                ),
              if (startText != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    startText.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: AppThemeValues.textSize17,
                        color: context.resources.color.colorBlack),
                  ),
                ),
              if (startText != null)
                Container(
                  width: 2,
                  height: 23,
                  color: context.resources.color.colorGrey,
                ),
              Expanded(
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  enabled: enabled,
                  inputFormatters: <TextInputFormatter>[
                    if (inputType == TextInputType.name)
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    if (inputType == TextInputType.phone)
                      FilteringTextInputFormatter.allow(RegExp("[0-9+]")),

                  ],
                  // Only numbers can be entered
                  obscureText: inputType == TextInputType.visiblePassword,
                  cursorColor: context.resources.color.colorPrimary,
                  onEditingComplete: () => textInputAction == null
                      ? context.nextEditableTextFocus()
                      : Utils().hideKeyboard(Get.context!),
                  textAlign: TextAlign.start,
                  keyboardType: inputType,
                  controller: controller,
                  maxLength: maxLength,
                  minLines: 1,
                  textInputAction: textInputAction ?? TextInputAction.next,
                  maxLines: maxLines,
                  onChanged: (text) {
                    isEmpty.value = text.isEmpty;
                    if (onTextChanged != null) {
                      onTextChanged!(text);
                    }
                  },
                  style:TextStyle(
                          fontSize: fontSize ?? AppThemeValues.textSize18,
                          fontFamily: 'DM Sans Text',
                          fontWeight: fontWeight ?? FontWeight.w400,
                          color:
                          context.resources.color.colorBlackMain),
                  decoration: InputDecoration(
                      counter: Offstage(),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: hint,
                      hintStyle:TextStyle(
                              fontFamily: 'DM Sans Text',
                          color: context.resources.color.colorGrey2,
                              fontWeight: fontWeight ?? FontWeight.w400,
                              fontSize: fontSize ?? AppThemeValues.textSize16)

    ),
                ),
              ),
              if (endIcon != null)
                SizedBox(
                  width: margin ?? 8,
                ),
              if (endIcon != null)
                GestureDetector(
                  onTap: () {
                    endIconClick?.call();
                  },
                  child: Image.asset(
                    endIcon.toString(),
                    height: 26,
                  ),
                ),
              if (endIcon != null)
                SizedBox(
                  width: margin ?? 8,
                ),
            ],
          ),
        ));
  }
}
