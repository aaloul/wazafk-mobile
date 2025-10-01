import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../utils/res/AppIcons.dart';
import '../utils/utils.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({
    super.key,
    this.title,
    this.onBack,
    this.endWidget,
    this.color,
    this.hasBack,
  });

  final String? title;
  final Function? onBack;
  final bool? hasBack;
  final Widget? endWidget;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: Utils().isRTL() ? null : 0,
            right: Utils().isRTL() ? 0 : null,
            child: hasBack ?? true
                ? GestureDetector(
                    onTap: () {
                if (onBack == null) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(Get.context!);
                  }
                } else {
                  onBack?.call();
                }
              },
              child: RotatedBox(
                quarterTurns: Utils().isRTL() ? 2 : 0,
                child: Image.asset(
                  AppIcons.back,
                  width: 28,
                  color: color ?? context.resources.color.colorGrey,
                ),
              ),
                  )
                : SizedBox(),
          ),
          Center(
            child: PrimaryText(
              textAlign: TextAlign.center,
              text: title ?? '',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textColor: color ?? context.resources.color.colorGrey,
            ),
          ),
          if (endWidget != null)
            Positioned(
              left: Utils().isRTL() ? 0 : null,
              right: Utils().isRTL() ? null : 0,
              child: endWidget!,
            ),
        ],
      ),
    );
  }
}
