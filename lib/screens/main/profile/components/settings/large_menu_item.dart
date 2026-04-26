import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';
import '../../../../../utils/utils.dart';

class LargeMenuItem extends StatelessWidget {
  const LargeMenuItem({
    super.key,
    required this.title,
    required this.onClick,
    required this.color,
    required this.border,
    required this.icon,
  });

  final String title;
  final String icon;
  final Function onClick;
  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 32),

            Container(
              width: 1.5,
              height: 30,
              margin: EdgeInsets.symmetric(horizontal: 12),
              color: context.resources.color.colorGrey29,
            ),

            Expanded(
              child: PrimaryText(
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: context.resources.color.colorGrey26,
              ),
            ),

            RotatedBox(
              quarterTurns: Utils().isRTL() ? 2 : 0,
              child: Image.asset(AppIcons.arrowRight3, width: 24),
            ),
          ],
        ),
      ),
    );
  }
}
