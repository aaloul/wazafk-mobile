import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/search_widget.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'help_center_controller.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpCenterController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopHeader(hasBack: true, title: strings.helpCenter),
            const SizedBox(height: 20),

            // "How can we help you?" + search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryText(
                text: strings.howCanWeHelpYou,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                textColor: colors.colorBlack,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchWidget(
                hint: strings.searchQuestion,
                height: 48,
                borderRadius: 12,
                onTextChanged: (v) => controller.searchQuery.value = v,
              ),
            ),
            const SizedBox(height: 20),

            // FAQs label + audience tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryText(
                text: strings.faqs,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: colors.colorBlack,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final selected = controller.selectedAudience.value;
                return Row(
                  children: [
                    _AudienceTab(
                      label: strings.general,
                      selected: selected == strings.general,
                      onTap: () =>
                          controller.selectedAudience.value = strings.general,
                    ),
                    const SizedBox(width: 10),
                    _AudienceTab(
                      label: strings.employer,
                      selected: selected == strings.employer,
                      onTap: () =>
                          controller.selectedAudience.value = strings.employer,
                    ),
                    const SizedBox(width: 10),
                    _AudienceTab(
                      label: strings.freelancer,
                      selected: selected == strings.freelancer,
                      onTap: () =>
                          controller.selectedAudience.value = strings.freelancer,
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: ProgressBar());
                }
                final faqs = controller.filteredFaqs;
                if (faqs.isEmpty) {
                  return Center(
                    child: PrimaryText(
                      text: strings.noFaqsAvailable,
                      fontSize: 14,
                      textColor: colors.colorGrey,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: faqs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) =>
                      _FaqItem(index: index, controller: controller),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudienceTab extends StatelessWidget {
  const _AudienceTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.colorPrimary : colors.colorWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? colors.colorPrimary : colors.colorGrey4,
            width: 1,
          ),
        ),
        child: PrimaryText(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          textColor: selected ? colors.colorWhite : colors.colorGrey,
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.index, required this.controller});

  final int index;
  final HelpCenterController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Obx(() {
      final faq = controller.filteredFaqs[index];
      final isExpanded = controller.expandedIndex.value == index;
      return GestureDetector(
        onTap: () => controller.toggleExpand(index),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.colorWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.colorGrey9, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PrimaryText(
                    text: 'Q${index + 1}:',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: colors.colorGrey10,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: PrimaryText(
                      text: faq.question ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      textColor: colors.colorBlack,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Image.asset(
                      AppIcons.arrowDown,
                      width: 16,
                      color: colors.colorGrey8,
                    ),
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 10),
                Divider(height: 1, color: colors.colorGrey9, thickness: 0.5),
                const SizedBox(height: 10),
                PrimaryText(
                  text: faq.answer ?? '',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  textColor: colors.colorGrey10,
                  height: 1.5,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
