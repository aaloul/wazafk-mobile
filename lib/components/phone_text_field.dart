import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppTheme.dart';
import '../utils/utils.dart';

class PhoneTextFiled extends StatelessWidget {
  PhoneTextFiled({
    super.key,
    required this.hint,
    this.onTextChanged,
    this.controller,
    this.height,
    required this.onCCChanged,
  });

  final String hint;
  double? height;
  Function? onTextChanged;
  final Function onCCChanged;
  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: context.resources.color.colorGrey3,
          width: .5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CountryCodePicker(
            onChanged: (cc) {
              onCCChanged(cc.dialCode.toString());
            },
            initialSelection: 'LB',
            padding: const EdgeInsets.symmetric(horizontal: 0),
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            showDropDownButton: false,
            alignLeft: false,
            onInit: (cc) {
              onCCChanged(cc?.dialCode.toString());
            },
          ),
          Container(
            height: 24,
            width: 1,
            color: context.resources.color.colorGrey7,
          ),

          Expanded(
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              obscureText: false,
              cursorColor: context.resources.color.colorPrimary,
              onEditingComplete: () => Utils().hideKeyboard(Get.context!),
              textAlign: TextAlign.start,
              keyboardType: TextInputType.phone,
              controller: controller,
              minLines: 1,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              onChanged: (text) {
                if (onTextChanged != null) {
                  onTextChanged!(text);
                }
              },
              style: TextStyle(
                fontSize: AppThemeValues.textSize18,
                fontFamily: 'DM Sans Text',
                fontWeight: FontWeight.w400,
                color: context.resources.color.colorBlackMain,
              ),
              decoration: InputDecoration(
                counter: Offstage(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: 'DM Sans Text',
                  color: context.resources.color.colorGrey2,
                  fontWeight: FontWeight.w400,
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
