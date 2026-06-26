import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/model/SupportCategoriesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'get_support_controller.dart';

class GetSupportScreen extends StatelessWidget {
  const GetSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetSupportController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.getSupport),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  const _IntroCard(),
                  const SizedBox(height: 20),
                  Obx(() {
                    if (controller.isLoadingCategories.value) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: Center(child: ProgressBar()),
                      );
                    }
                    if (controller.supportCategories.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.supportCategories
                          .map((c) => _TopicRow(category: c))
                          .toList(),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.colorPrimary, width: 1),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            colors.colorPrimaryLight,
            // Soft medium blue (matches design — lighter than full primary).
            Color.alphaBlend(
              colors.colorPrimary.withValues(alpha: 0.55),
              Colors.white,
            ),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: strings.doYouHaveAnIssue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorBlack,
                ),
                const SizedBox(height: 8),
                PrimaryText(
                  text: strings.getSupportSubtitle,
                  fontSize: 13,
                  textColor: colors.colorBlack4,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(13),
            child: Image.asset(
              AppIcons.message,
              color: colors.colorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({required this.category});

  final SupportCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final controller = Get.find<GetSupportController>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.startChat(category),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.colorGrey15, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: category.name ?? '',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: colors.colorBlack,
                  ),
                  if (category.description?.isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    PrimaryText(
                      text: category.description!,
                      fontSize: 12,
                      textColor: colors.colorGrey,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => controller.startingCategoryHashcode.value ==
                    category.hashcode
                ? const ProgressBar(width: 18)
                : Image.asset(
                    AppIcons.arrowRight2,
                    width: 16,
                    color: colors.colorGrey,
                  )),
          ],
        ),
      ),
    );
  }
}
