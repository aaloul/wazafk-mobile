import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

/// Invite-friend bottom sheet (Figma p189). Opens over the Share App screen
/// when the Invite button is tapped. Provides two channels — WhatsApp and
/// Email — each launches the corresponding system intent with a prefilled
/// invite message.
class InviteSheet extends StatelessWidget {
  const InviteSheet({super.key});

  static const _inviteMessage =
      "Hey! Check out Wazafk — find or post jobs in seconds. "
      "Download it here: https://wazafk.app";

  Future<void> _sendWhatsapp() async {
    final uri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(_inviteMessage)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    Get.back();
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      query: 'subject=${Uri.encodeComponent("Join me on Wazafk")}'
          '&body=${Uri.encodeComponent(_inviteMessage)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.colorGrey2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            PrimaryText(
              text: strings.invite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: colors.colorBlack,
            ),
            const SizedBox(height: 14),
            _Option(
              icon: AppIcons.inviteWhatsappIcon,
              label: strings.inviteByWhatsapp,
              onTap: _sendWhatsapp,
            ),
            Container(
              height: 1,
              margin: const EdgeInsetsDirectional.only(start: 56),
              color: colors.colorGrey4,
            ),
            _Option(
              icon: AppIcons.inviteEmailIcon,
              label: strings.inviteByEmail,
              onTap: _sendEmail,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Image.asset(icon, width: 24, height: 24),
            const SizedBox(width: 14),
            Expanded(
              child: PrimaryText(
                text: label,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
