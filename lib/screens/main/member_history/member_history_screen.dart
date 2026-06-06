import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'components/review_card.dart';
import 'member_history_controller.dart';

/// Generic full-page list of reviews. Hiring History (Figma p85) shows
/// reviews a member received as a client; Work History (p216) shows
/// reviews received as a freelancer. Same layout, different label.
class MemberHistoryScreen extends StatelessWidget {
  const MemberHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MemberHistoryController());
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final isHiring = controller.args.type == HistoryType.hiring;
    final title =
        isHiring ? strings.hiringHistory : strings.workHistory;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                TopHeader(hasBack: true, title: title),
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colors.colorPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppIcons.filter,
                          width: 16,
                          color: colors.colorWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: ProgressBar());
                }
                if (controller.reviews.isEmpty) {
                  return Center(
                    child: PrimaryText(
                      text: strings.noContentAvailable,
                      fontSize: 14,
                      textColor: colors.colorGrey,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: controller.reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) =>
                      ReviewCard(review: controller.reviews[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
