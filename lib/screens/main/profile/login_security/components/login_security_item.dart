import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/primary_text.dart';
import '../../../../../utils/res/AppIcons.dart';
import '../../../../../utils/utils.dart';

class LoginSecurityItem extends StatelessWidget {
  const LoginSecurityItem({
    super.key,
    required this.title,
    required this.onClick,
    required this.icon,
  });

  final String title;
  final String icon;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 18,
              color: colors.colorGrey,
            ),
            Container(
              width: 1,
              height: 16,
              color: colors.colorGrey4,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            Expanded(
              child: PrimaryText(
                text: title,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                textColor: colors.colorBlack,
              ),
            ),
            RotatedBox(
              quarterTurns: Utils().isRTL() ? 2 : 0,
              child: Image.asset(
                AppIcons.arrowRight2,
                width: 14,
                color: colors.colorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
