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
              ? context.resources.color.colorWhite
              : context.resources.color.background2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: option.selected.value
                ? context.resources.color.colorPrimary
                : context.resources.color.colorGrey25
          )
        ),
        child: PrimaryText(
          text: option.name.toString(),
          fontWeight: FontWeight.w500,
          textColor: option.selected.value
              ? context.resources.color.colorPrimary
              : context.resources.color.colorGrey26,
        ),
      ),
    );
  }
}
