import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/model/ActivityLogResponse.dart';
import 'package:wazafak_app/screens/main/profile/login_security/where_logged_in/where_logged_in_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class WhereLoggedInScreen extends StatelessWidget {
  const WhereLoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WhereLoggedInController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.whereYoureLoggedIn),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: ProgressBar());
                }
                final current = controller.currentSession.value;
                final others = controller.otherSessions;
                if (current == null && others.isEmpty) {
                  return Center(
                    child: PrimaryText(
                      text: strings.noActiveSessions,
                      fontSize: 14,
                      textColor: colors.colorGrey,
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.colorWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.colorGrey15, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (current != null) ...[
                          _Label(text: strings.currentlyLoggedInOn),
                          const SizedBox(height: 10),
                          _SessionCard(session: current),
                        ],
                        if (others.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _Label(text: strings.loginsOnOtherDevices),
                          const SizedBox(height: 10),
                          ...others.map(
                            (s) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _SessionCard(
                                session: s,
                                onTap: () =>
                                    _showLogoutSheet(context, controller, s),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return PrimaryText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      textColor: context.resources.color.colorGrey16,
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session, this.onTap});

  final LoginSession session;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final subtitle = [
      if (session.location.isNotEmpty) session.location,
      if (session.dateTimeLabel.isNotEmpty) 'on ${session.dateTimeLabel}',
    ].join(' - ');

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.colorGrey4, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text: session.device,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              textColor: colors.colorBlack,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              PrimaryText(
                text: subtitle,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: colors.colorGrey,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void _showLogoutSheet(
  BuildContext context,
  WhereLoggedInController controller,
  LoginSession session,
) {
  final colors = context.resources.color;
  final strings = context.resources.strings;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.colorWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.colorGrey2,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 22),
          PrimaryText(
            text: strings.logout,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const SizedBox(height: 14),
          PrimaryText(
            text: strings.notYouLoggedInLogoutOf(session.device),
            fontSize: 13,
            textColor: colors.colorGrey,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            title: strings.logout,
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.logoutSession(session);
            },
          ),
        ],
      ),
    ),
  );
}
