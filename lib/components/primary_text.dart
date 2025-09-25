import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppTheme.dart';

class PrimaryText extends StatelessWidget {
  const PrimaryText({
    super.key,
    required this.text,
    this.fontWeight,
    this.textColor,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.height,
    this.isLined,
    this.isUnderLined,
  });

  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  final TextAlign? textAlign;
  final double? height;
  final int? maxLines;
  final bool? isLined;
  final bool? isUnderLined;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 200,
      overflow: TextOverflow.ellipsis,
      textDirection: (text.contains("\$+") || text.contains("\$-"))
          ? TextDirection.ltr
          : null,
      style: TextStyle(
        decoration: TextDecoration.combine([
          if (isUnderLined ?? false) TextDecoration.underline,
          // if (GetPlatform.isAndroid)
          if (isLined ?? false) TextDecoration.lineThrough,
        ]),
        fontFamily: 'SF Pro Text',
        height: height ?? 1.2,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize ?? AppThemeValues.textSize16,
        decorationColor: textColor ?? context.resources.color.colorBlack,
        color: textColor ?? context.resources.color.colorBlack,
      ),
    );
  }
}
