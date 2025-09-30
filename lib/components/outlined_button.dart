import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppTheme.dart';

class PrimaryOutlinedButton extends StatelessWidget {
  PrimaryOutlinedButton({
    required this.title,
    required this.onPressed,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.fontWeight,
    this.margin,
    this.hasRedDot,
    this.height,
    this.width,
    this.color,
    this.borderRadius,
    this.icon,
    super.key,
  });

  String title;
  Color? textColor;
  Color? borderColor;
  Color? color;
  Function onPressed;
  double? fontSize;
  double? height;
  double? width;
  double? margin;
  double? borderRadius;
  FontWeight? fontWeight;
  bool? hasRedDot;
  String? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
        width: width ?? double.infinity,
        height: height ?? 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          border: Border.all(
            color: borderColor ?? context.resources.color.colorPrimary,
            width: 1,
          ),
        ),
        child: hasRedDot ?? false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Image.asset(icon!, width: 20),
                  if (icon != null) const SizedBox(width: 6),

                  PrimaryText(
                    text: title,
                    fontSize: fontSize ?? AppThemeValues.textSize18,
                    fontWeight: fontWeight ?? FontWeight.w500,
                    textColor:
                        textColor ?? context.resources.color.colorPrimary,
                    textAlign: TextAlign.center,
                    height: 1.3,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.resources.color.colorRed2,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Image.asset(icon!, width: 24),
                  if (icon != null) const SizedBox(width: 4),

                  PrimaryText(
                    text: title,
                    textColor:
                        textColor ?? context.resources.color.colorPrimary,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    fontSize: fontSize ?? AppThemeValues.textSize18,
                  ),
                ],
              ),
      ),
    );
  }
}
