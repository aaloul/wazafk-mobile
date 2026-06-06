import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

/// Top notice banner on activation/publish screens.
///
/// Two variants per Figma:
///  - **Info** (p191) — light blue background, no leading icon, plain copy.
///  - **Promo** (p194, p204, p223) — green tint, leading check circle,
///    bold "First X on us!🔥" heading.
class ActivationBanner extends StatelessWidget {
  const ActivationBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.isPromo = false,
  });

  final String title;
  final String subtitle;
  final bool isPromo;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final bg = isPromo ? colors.colorGreen5 : colors.colorPrimaryLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPromo) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colors.colorGreen6,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                AppIcons.checkCircle,
                width: 16,
                color: colors.colorWhite,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: PrimaryText(
                        text: title,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textColor: colors.colorBlack,
                      ),
                    ),
                    if (isPromo) ...[
                      const SizedBox(width: 4),
                      const PrimaryText(text: '🔥', fontSize: 14),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                PrimaryText(
                  text: subtitle,
                  fontSize: 12,
                  textColor: colors.colorGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
