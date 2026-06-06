import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'share_app_controller.dart';

/// Figma p189 — Share App with the Invite bottom sheet trigger.
class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ShareAppController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.shareApp),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        AppIcons.shareIntro,
                        width: Get.width * 0.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryText(
                      text: strings.inviteFriend,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorPrimary,
                    ),
                    const SizedBox(height: 6),
                    _HeroSubtitle(),
                    const SizedBox(height: 20),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: PrimaryText(
                        text: strings.inviteStepsPriorVoucher,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: colors.colorGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: colors.colorWhite,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: colors.colorGrey4, width: 1),
                      ),
                      child: Column(
                        children: [
                          // _Step(
                          //   icon: AppIcons.shareDownloadIcon,
                          //   title: strings.downloadStep,
                          //   desc: strings.downloadStepDesc,
                          // ),
                          // _StepDivider(),
                          _Step(
                            icon: AppIcons.shareVerifyIcon,
                            title: strings.verification,
                            desc: strings.verificationDesc,
                          ),
                          _StepDivider(),
                          _Step(
                            icon: AppIcons.shareActionIcon,
                            title: strings.inviteAction,
                            desc: strings.inviteActionDesc,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: PrimaryButton(
                title: strings.invite,
                onPressed: () => SheetHelper.showInviteSheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mixed-colour hero subtitle. The promo prefix is bold black, the parenthesized
/// cap is rendered in lighter grey on the same line per Figma p189.
class _HeroSubtitle extends StatelessWidget {
  static const _prefix = "Get 10% Off Your Next Hire";
  static const _suffix = " (Up To 10\$)";

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        children: [
          TextSpan(
            text: _prefix,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.colorBlack,
              fontFamily: 'SF Pro Text',
            ),
          ),
          TextSpan(
            text: _suffix,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colors.colorGrey,
              fontFamily: 'SF Pro Text',
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsetsDirectional.only(start: 56),
      color: context.resources.color.colorGrey4,
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.icon,
    required this.title,
    required this.desc,
  });

  final String icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Image.asset(
              icon,
              fit: BoxFit.contain,
              color: colors.colorGrey2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorBlack,
                ),
                const SizedBox(height: 2),
                PrimaryText(
                  text: desc,
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
