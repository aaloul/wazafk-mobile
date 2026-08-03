import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'primary_text.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {required this.title,
      required this.onPressed,
      this.textColor,
      this.fontSize,
      this.fontWeight,
    this.fontFamily,
      this.margin,
      this.height,
      this.color,
      this.enabled,
      this.icon,
      this.leadingIcon,
      this.borderRadius,
      this.width,
      super.key});

  String title;
  Color? textColor;
  Color? color;
  Function onPressed;
  double? fontSize;
  double? height;
  double? width;
  double? margin;
  double? borderRadius;
  String? icon;
  Widget? leadingIcon;
  FontWeight? fontWeight;
  String? fontFamily;
  bool? enabled = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          splashFactory: InkRipple.splashFactory,
          overlayColor: context.resources.color.background,
          backgroundColor: (enabled ?? true)
              ? (color ?? context.resources.color.colorPrimary)
              : context.resources.color.colorGrey,
          // background color
          foregroundColor: textColor ?? Colors.white,
          // text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        onPressed: () {
          if (enabled ?? true) {
            onPressed.call();
          }
        },
        child: (leadingIcon != null || icon != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    const SizedBox(width: 6),
                  ],
                  PrimaryText(
                    text: title,
                    fontFamily: fontFamily,
                    fontSize: fontSize ?? 16,
                    fontWeight: fontWeight ?? FontWeight.w500,
                    textColor: textColor ?? context.resources.color.colorWhite,
                    textAlign: TextAlign.center,
                    height: 1.3,
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 4),
                    Image.asset(icon.toString(), width: 24, height: 24),
                  ],
                ],
              )
            : Center(
                child: PrimaryText(
                  text: title,
                  fontFamily: fontFamily,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  textColor: textColor ?? context.resources.color.colorWhite,
                  textAlign: TextAlign.center,
                  height: 1.3,
                ),
              ),
      ),
    );


  }
}
