import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/InterestOptionsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class InterestItem extends StatelessWidget {
  const InterestItem({super.key, required this.option, required this.onSelect});

  final InterestOption option;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect(option);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: option.selected.value
              ? context.resources.color.colorPrimary
              : context.resources.color.colorGrey4,
          borderRadius: BorderRadius.circular(100),
        ),
        child: PrimaryText(
          text: option.name.toString(),
          fontWeight: FontWeight.w500,
          textColor: option.selected.value
              ? context.resources.color.colorWhite
              : context.resources.color.colorGrey,
        ),
      ),
    );
  }
}
