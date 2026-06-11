import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class HomeCategoryItem extends StatelessWidget {
  const HomeCategoryItem({
    super.key,
    required this.label,
    required this.onTap,
    this.iconUrl,
    this.iconAsset,
    this.isSelected = false,
  });

  /// Label shown under the card.
  final String label;

  /// Network icon (real categories). Ignored when [iconAsset] is provided.
  final String? iconUrl;

  /// Local asset icon (used by the "All" card).
  final String? iconAsset;

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.resources.color.colorPrimary;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 75,
              height: 75,
              child: Card(
                color: Colors.white,
                elevation: isSelected ? 14 : 12,
                shadowColor: isSelected ? primary.withOpacity(0.45) : Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? primary : context.resources.color.colorGrey15,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: iconAsset != null
                      ? Image.asset(
                          iconAsset!,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : PrimaryNetworkImage(
                          url: iconUrl.toString(),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            PrimaryText(
              text: label,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              maxLines: 1,
              textAlign: TextAlign.center,
              textColor: isSelected ? primary : context.resources.color.colorBlack,
            ),
            const SizedBox(height: 5),
            // Selected indicator underline spanning the full card (design p35).
            Container(
              width: double.infinity,
              height: 3,
              decoration: BoxDecoration(
                color: isSelected ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
