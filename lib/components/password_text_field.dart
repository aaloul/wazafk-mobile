import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/extentions.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppDimentions.dart';
import '../utils/res/AppTheme.dart';
import '../utils/utils.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField({
    super.key,
    required this.hint,
    required this.inputType,
    this.onTextChanged,
    this.controller,
    required this.startIcon,
  });

  final String hint;
  final String? startIcon;
  final TextInputType inputType;
  Function? onTextChanged;
  TextEditingController? controller = TextEditingController();
  bool _obscurePassword = true;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  var isEmpty = true.obs;
  var isFocused = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppDimensions.textFieldHeight,
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              width: 1, color:  context.resources.color.colorGrey2),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          if (widget.startIcon != null)
            Image.asset(
              widget.startIcon.toString(),
              height: 30,
              color: context.resources.color.colorPrimary,
            ),
          Expanded(
            child: Focus(
              onFocusChange: (f) {
                isFocused.value = f;
              },
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                obscureText: widget._obscurePassword,
                cursorColor: context.resources.color.colorPrimary,
                onEditingComplete: () => context.nextEditableTextFocus(),
                textAlign: TextAlign.start,
                keyboardType: widget.inputType,
                controller: widget.controller,
                minLines: 1,
                textInputAction: TextInputAction.next,
                onChanged: (text) {
                  isEmpty.value = text.isEmpty;
                  if (widget.onTextChanged != null) {
                    widget.onTextChanged!(text);
                  }
                },
                style: TextStyle(
                  height: 1.2,
                  fontSize: AppThemeValues.textSize17,
                  fontFamily: 'DM Sans Text',
                  fontWeight: FontWeight.w400,
                  color: context.resources.color.colorBlackMain,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: context.resources.color.colorGrey,
                      widget._obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: _toggle,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Utils().isRTL() ? 10 : 14,
                    horizontal: 4,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontFamily: 'DM Sans Text',
                    color: context.resources.color.colorGrey2,
                    fontWeight: FontWeight.w400,
                    fontSize: AppThemeValues.textSize16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      widget._obscurePassword = !widget._obscurePassword;
    });
  }
}
