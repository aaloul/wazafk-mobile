import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/category_chooser.dart';
import 'package:wazafak_app/components/form_choice_chip.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/primary_text_field.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/screens/main/profile/activation/components/activation_banner.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'add_job_controller.dart';
import 'components/job_address_field.dart';
import 'components/job_location_type_widget.dart';
import 'components/job_periodicity_widget.dart';
import 'components/job_schedule_fields.dart';
import 'components/job_skills_choose_widget.dart';

/// Job post form — design p185 ("Job Post 1 / 2") and p186 ("Edit job").
///
/// Step 1 collects the post; "Continue" hands over to [PublishJobScreen]
/// (p194) which confirms the fee and actually posts. Editing an existing post
/// skips the publish step and saves directly.
class AddJobScreen extends StatelessWidget {
  const AddJobScreen({super.key});

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
    final controller = Get.put(AddJobController());
    final homeController = Get.find<HomeController>();
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final isEdit = controller.isEditMode;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
              hasBack: true,
              title: isEdit ? strings.editJobTitle : strings.jobPostTitle,
              endWidget: isEdit
                  ? null
                  : PrimaryText(
                      text: '1 / 2',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: colors.colorGrey,
                    ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "1 free post. No charge yet" (p185) — first post only.
                    if (!isEdit)
                      Obx(() {
                        // Reads controller.limits, so it refreshes once
                        // app/limits lands.
                        if (!controller.showFreePostBanner) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ActivationBanner(
                            title: strings.freePostsLeft(
                              controller.freeJobPostsLeft,
                            ),
                            subtitle: strings.noChargeYet,
                            isPromo: true,
                            inline: true,
                          ),
                        );
                      }),

                    // Card 1 — the post itself.
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
                              if (homeController.isLoadingJobCategories.value ||
                                  homeController.jobCategories.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: ProgressBar()),
                                );
                              }
                              return Obx(
                                () => CategoryChooser(
                                  label: strings.category,
                                  text: strings.selectCategory,
                                  isMandatory: true,
                                  withArrow: true,
                                  labelFontSize: 12,
                                  list: homeController.jobCategories,
                                  selected: controller.selectedCategory.value,
                                  onSelect: (category) {
                                    if (category != null) {
                                      controller.selectCategory(category);
                                    }
                                  },
                                ),
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

                            JobLocationTypeWidget(),
                            JobAddressField(),

                            const SizedBox(height: 16),

                            JobPeriodicityWidget(),

                            const SizedBox(height: 12),

                            JobStartDateField(),
                            const SizedBox(height: 10),
                            JobStartTimeField(),
                            const SizedBox(height: 10),
                            JobExpiryDateField(),
                            const SizedBox(height: 10),
                            JobExpiryTimeField(),

                            const SizedBox(height: 16),

                            FormFieldLabel(text: strings.budget, isMandatory: true),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryTextField(
                                    controller: controller.totalPriceController,
                                    hint: strings.amountInUsd,
                                    inputType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                PrimaryText(
                                  text: strings.perJob,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: colors.colorBlack4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 2 — Job Details.
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
                              text: strings.jobDetails,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              textColor: colors.colorBlack4,
                            ),
                            const SizedBox(height: 16),

                            JobSkillsChooseWidget(),

                            MultilineLabeledTextField(
                              controller: controller.overviewController,
                              label: strings.overview,
                              hint: strings.jobOverviewHint,
                              maxLines: 20,
                              height: 100,
                              margin: 0,
                              labelFontSize: 12,
                              inputType: TextInputType.text,
                              isPassword: false,
                              isMandatory: true,
                            ),

                            const SizedBox(height: 8),

                            MultilineLabeledTextField(
                              controller: controller.responsibilitiesController,
                              label: strings.responsibilities,
                              hint: strings.jobOverviewHint,
                              maxLines: 20,
                              height: 100,
                              margin: 0,
                              labelFontSize: 12,
                              inputType: TextInputType.text,
                              isPassword: false,
                              isMandatory: true,
                            ),

                            const SizedBox(height: 8),

                            MultilineLabeledTextField(
                              controller: controller.requirementsController,
                              label: strings.requirements,
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
                        title: isEdit ? strings.postJob : strings.continueBtn,
                        onPressed: () {
                          if (isEdit) {
                            controller.addJob();
                          } else {
                            controller.continueToPublish();
                          }
                        },
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
