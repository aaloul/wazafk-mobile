import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../../components/primary_text.dart';

class IdentityUploadItem extends StatelessWidget {
  const IdentityUploadItem({
    super.key,
    required this.label,
    required this.onClick,
    required this.isMandatory,
    required this.isOptional,
  });

  final String label;
  final Function onClick;
  final bool isMandatory;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PrimaryText(
              text: label,
              textColor: context.resources.color.colorGrey3,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            const SizedBox(width: 1),
            if (isMandatory)
              PrimaryText(
                text: '*',
                textColor: context.resources.color.colorGrey3,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            if (isOptional ?? false)
              Flexible(
                child: PrimaryText(
                  text: '(optional)',
                  textColor: context.resources.color.colorGrey3,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        SizedBox(
          width: double.infinity,
          height: 170,
          child: DottedBorder(
            color: context.resources.color.colorGrey2,
            strokeWidth: 1,
            dashPattern: [8, 4],
            borderType: BorderType.RRect,
            radius: Radius.circular(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AppIcons.scan, width: 42),
                    SizedBox(height: 6),
                    PrimaryText(
                      text: "Tap to Scan",
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorGrey3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
