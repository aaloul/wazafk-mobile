import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';
import 'package:wazafak_app/utils/utils.dart';

/// Shared white bordered card used across the engagement detail screens.
const engagementCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0xFFE5E5E5), width: 1),
  ),
);

String engagementWorkLocationTypeName(BuildContext context, String? code) {
  switch (code) {
    case 'RMT':
      return context.resources.strings.remote;
    case 'HYB':
      return context.resources.strings.hybrid;
    case 'SIT':
      return context.resources.strings.onsite;
    default:
      return context.resources.strings.notAvailable;
  }
}

bool engagementIsImageFile(String url) {
  final extension = url.toLowerCase().split('.').last.split('?').first;
  return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
}

Future<void> engagementOpenFileInBrowser(String url, BuildContext context) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Resources.of(context).strings.couldNotLaunchUrl(url);
  }
}

void engagementShowExpandedImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: PrimaryNetworkImage(
                  url: imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const PrimaryText(
                    text: '✕',
                    textColor: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Engagement status pill (Request / Application / Submitted / Upcoming / etc.).
/// Backend hands us a saturated hex; we use it as the text colour and derive a
/// pastel background by mixing the hex with white.
class EngagementStatusPill extends StatelessWidget {
  const EngagementStatusPill({
    super.key,
    required this.label,
    required this.hexColor,
  });

  final String label;
  final String hexColor;

  @override
  Widget build(BuildContext context) {
    final base = HexColor(hexColor);
    final bg = Color.alphaBlend(base.withValues(alpha: 0.14), Colors.white);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: PrimaryText(
        text: label,
        textColor: base,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}

/// Row with a back button and (optionally) the status pill, used at the top of
/// the white header card on each engagement detail screen.
class EngagementBackBar extends StatelessWidget {
  const EngagementBackBar({super.key, this.statusLabel, this.statusColor});

  final String? statusLabel;
  final String? statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RotatedBox(
            quarterTurns: Utils().isRTL() ? 2 : 0,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Image.asset(AppIcons.back3, width: 38),
            ),
          ),
          if (statusLabel != null && statusColor != null)
            EngagementStatusPill(label: statusLabel!, hexColor: statusColor!),
        ],
      ),
    );
  }
}

/// Centered app bar (back + title) used by the Inquiry screen (design p58).
class EngagementCenterAppBar extends StatelessWidget {
  const EngagementCenterAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Utils().isRTL()
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.resources.color.colorGrey25,
                    width: 1,
                  ),
                ),
                child: RotatedBox(
                  quarterTurns: Utils().isRTL() ? 2 : 0,
                  child: Image.asset(AppIcons.back3, width: 24),
                ),
              ),
            ),
          ),
          PrimaryText(
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            textColor: context.resources.color.colorBlack,
          ),
        ],
      ),
    );
  }
}

/// White titled section card on the grey body background.
class EngagementSectionCard extends StatelessWidget {
  const EngagementSectionCard({
    super.key,
    this.title,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  final String? title;
  final Widget child;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: engagementCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            PrimaryText(
              text: title!,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              textColor: context.resources.color.colorBlack,
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }
}

/// Grey filled read-only value box (description / hours / message bodies).
class EngagementInfoBox extends StatelessWidget {
  const EngagementInfoBox({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.resources.color.colorGrey28,
        borderRadius: BorderRadius.circular(12),
      ),
      child: PrimaryText(
        text: text,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        textColor: context.resources.color.colorGrey7,
      ),
    );
  }
}
