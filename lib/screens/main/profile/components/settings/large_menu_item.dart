import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 30),

            Container(
              width: 2,
              height: 22,
              margin: EdgeInsets.symmetric(horizontal: 14),
              color: context.resources.color.colorGrey.withOpacity(.1),
            ),

            Expanded(
              child: PrimaryText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                textColor: context.resources.color.colorGrey,
              ),
            ),

            Image.asset(AppIcons.arrowRight2, width: 18),
          ],
        ),
      ),
    );
  }
}
