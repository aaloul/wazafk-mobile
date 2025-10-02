import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_radio.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../../components/primary_text.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({
    super.key,
    required this.onSelectLanguage,
    required this.language,
    required this.isSelected,
  });

  final Function onSelectLanguage;
  final bool isSelected;
  final Map<String, String> language;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelectLanguage(language['code']!);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? HexColor("#CDE9EE")
              : context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? HexColor("#CDE9EE")
                : context.resources.color.colorGrey9,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: PrimaryText(
                text: language['name']!,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: context.resources.color.colorGrey8,
              ),
            ),
            PrimaryRadio(checked: isSelected, width: 20),
          ],
        ),
      ),
    );
  }
}
