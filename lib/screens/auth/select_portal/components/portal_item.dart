import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class PortalItem extends StatelessWidget {
  const PortalItem({
    super.key,
    required this.title,
    required this.onClick, required this.selected,

  });

  final bool selected;
  final String title;
  final Function onClick;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick.call();
      },
      child:


      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        decoration: BoxDecoration(
            color: selected
                ? context.resources.color.colorWhite
                : context.resources.color.background2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                width: 1,
                color: selected
                    ? context.resources.color.colorPrimary
                    : context.resources.color.colorGrey25
            )
        ),
        child: PrimaryText(
          text: title.toString(),
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          textColor: selected
              ? context.resources.color.colorPrimary
              : context.resources.color.colorGrey26,
        ),
      )


    );
  }
}
