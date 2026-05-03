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
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick.call();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 22),

            Container(
              width: 1,
              height: 20,
              color: context.resources.color.colorGrey25,
              margin: EdgeInsets.symmetric(horizontal: 12),
            ),

            Expanded(
              child: PrimaryText(
                text: title,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textColor: context.resources.color.colorGrey26,
              ),
            ),

            RotatedBox(
              quarterTurns: Utils().isRTL() ? 2 : 0,
              child: Image.asset(AppIcons.arrowRight2, width: 18,color: context.resources.color.colorGrey26,),
            ),
          ],
        ),
      ),
    );
  }
}
