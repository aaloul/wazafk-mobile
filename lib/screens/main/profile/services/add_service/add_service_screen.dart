import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/category_chooser.dart';
import 'package:wazafak_app/components/form_choice_chip.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'add_service_controller.dart';
import 'components/service_location_widget.dart';
import 'components/service_rate_row.dart';
import 'components/working_hours_list.dart';

/// Service form — design p112 ("New Service") and p107 ("Edit Services").
class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
    boxShadow: [
      BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 0)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddServiceController());
    final homeController = Get.find<HomeController>();
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopHeader(
                hasBack: true,
                title: controller.isEditMode.value
                    ? strings.editServices
                    : strings.newService,
                endWidget: controller.isEditMode.value
                    ? const _ServiceStatusToggle()
                    : PrimaryText(
                        text: '1 / ${AddServiceController.totalSteps}',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        textColor: colors.colorGrey,
                      ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card 1 — the service itself.
                    Container(
                      decoration: _cardDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabeledTextFiled(
                              controller: controller.titleController,
                              hint: strings.title,
                              label: strings.title,
                              isMandatory: true,
                              isPassword: false,
                              labelFontSize: 12,
                              inputType: TextInputType.text,
                            ),

                            // Category dropdown + subcategory chips.
                            Obx(() {
                              if (homeController.categories.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: ProgressBar()),
                                );
                              }
                              final selected = controller.selectedCategory.value;
                              final exists = selected != null &&
                                  homeController.categories.any(
                                    (c) => c.hashcode == selected.hashcode,
                                  );
                              return CategoryChooser(
                                label: strings.category,
                                text: strings.selectCategory,
                                isMandatory: true,
                                withArrow: true,
                                labelFontSize: 12,
                                list: homeController.categories,
                                selected: exists ? selected : null,
                                onSelect: controller.selectCategory,
                              );
                            }),

                            Obx(() {
                              if (controller.isLoadingSubcategories.value) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: ProgressBar()),
                                );
                              }
                              if (controller.subcategories.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              final selectedHashcode =
                                  controller.selectedSubcategory.value?.hashcode;
                              return SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.subcategories.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 6),
                                  itemBuilder: (context, index) {
                                    final sub = controller.subcategories[index];
                                    return FormChoiceChip(
                                      label: sub.name ?? '',
                                      selected:
                                          selectedHashcode == sub.hashcode,
                                      fontWeight: FontWeight.w500,
                                      onTap: () =>
                                          controller.selectSubcategory(sub),
                                    );
                                  },
                                ),
                              );
                            }),

                            const SizedBox(height: 16),

                            const ServiceRateRow(),

                            const SizedBox(height: 16),

                            const ServiceLocationWidget(),

                            const SizedBox(height: 16),

                            MultilineLabeledTextField(
                              controller: controller.workExperienceController,
                              label: strings.workExperience,
                              hint: strings.jobOverviewHint,
                              maxLines: 20,
                              height: 100,
                              margin: 0,
                              labelFontSize: 12,
                              inputType: TextInputType.text,
                              isPassword: false,
                              isMandatory: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 2 — Skills. New services pick them on step 2/3
                    // (design p181); editing keeps them inline (p107).
                    Obx(() {
                      if (!controller.isEditMode.value) {
                        return const SizedBox.shrink();
                      }
                      if (controller.isLoadingSkills.value) {
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: _cardDecoration,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                child: Center(child: ProgressBar()),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }
                      if (controller.availableSkills.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final selectedHashcodes = controller.selectedSkills
                          .map((s) => s.hashcode)
                          .toSet();
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: _cardDecoration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: strings.skills,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    textColor: colors.colorGrey26,
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        controller.availableSkills.map((skill) {
                                      final isSelected = selectedHashcodes
                                          .contains(skill.hashcode);
                                      return _SkillPill(
                                        label: skill.name ?? '',
                                        selected: isSelected,
                                        onTap: () => controller
                                            .toggleSkillSelection(skill),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),

                    // Card 3 — Working Hours.
                    Container(
                      width: double.infinity,
                      decoration: _cardDecoration,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: WorkingHoursList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 4 — Portfolio file.
                    Container(
                      decoration: _cardDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: strings.portfolio,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              textColor: colors.colorGrey26,
                            ),
                            const SizedBox(height: 10),

                            GestureDetector(
                              onTap: () =>
                                  controller.pickPortfolioFile(context),
                              child: DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  radius: const Radius.circular(10),
                                  color: colors.colorGrey25,
                                  strokeWidth: 1.5,
                                  dashPattern: const [6.0, 4.0],
                                  padding: EdgeInsets.zero,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Image.asset(
                                    'assets/images/upload.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                              ),
                            ),

                            Obx(() {
                              final hasLocalFile =
                                  controller.portfolioFile.value != null;
                              final hasUrlFile =
                                  controller.portfolioFileUrl.value != null;
                              if (!hasLocalFile && !hasUrlFile) {
                                return const SizedBox.shrink();
                              }

                              final fileName = hasLocalFile
                                  ? (controller.portfolioFileName.value ?? '')
                                  : (controller.portfolioFileUrl.value!
                                      .split('/')
                                      .last);

                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: const Radius.circular(10),
                                    color: colors.colorPrimary,
                                    strokeWidth: 1.5,
                                    dashPattern: const [6.0, 4.0],
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colors.colorWhite,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: colors.colorPrimaryLight,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            controller.getPortfolioFileIcon(),
                                            color: colors.colorPrimary,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PrimaryText(
                                                text: fileName,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                textColor: colors.colorBlack4,
                                                maxLines: 1,
                                              ),
                                              if (hasLocalFile &&
                                                  controller.portfolioFileSize
                                                          .value !=
                                                      null) ...[
                                                const SizedBox(height: 4),
                                                PrimaryText(
                                                  text: controller
                                                      .getFormattedFileSize(
                                                    controller.portfolioFileSize
                                                        .value!,
                                                  ),
                                                  fontSize: 12,
                                                  textColor:
                                                      colors.colorPrimary,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: controller.removePortfolioFile,
                                          child: Icon(
                                            Icons.close,
                                            color: colors.colorPrimary,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 8),
                            PrimaryText(
                              text: strings.maxFileSizeNote,
                              textColor: colors.colorGrey29,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => controller.isLoading.value
                    ? ProgressBar()
                    : PrimaryButton(
                        title: controller.isEditMode.value
                            ? strings.saveChanges
                            : strings.continueBtn,
                        onPressed: controller.isEditMode.value
                            ? controller.addService
                            : controller.continueToSkills,
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Off / On segmented switch in the edit header (design p107).
class _ServiceStatusToggle extends StatelessWidget {
  const _ServiceStatusToggle();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddServiceController>();
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Obx(() {
      final isActive = controller.isServiceActive.value;
      Widget segment(String label, bool active) {
        return GestureDetector(
          onTap: () => controller.setServiceActive(active),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isActive == active ? colors.colorWhite : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive == active
                    ? colors.colorPrimary
                    : Colors.transparent,
              ),
            ),
            child: PrimaryText(
              text: label,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              textColor:
                  isActive == active ? colors.colorPrimary : colors.colorGrey8,
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colors.colorGrey4,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            segment(strings.offLabel, false),
            segment(strings.onLabel, true),
          ],
        ),
      );
    });
  }
}

/// Pill-shaped skill chip, same as the job form (design p185 / p181).
class _SkillPill extends StatelessWidget {
  const _SkillPill({
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
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? colors.colorPrimary : colors.colorGrey29,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.colorPrimary.withAlpha(60),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: PrimaryText(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          textColor: selected ? colors.colorPrimary : colors.colorGrey26,
        ),
      ),
    );
  }
}
