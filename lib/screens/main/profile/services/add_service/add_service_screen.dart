import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/area_choose_widget.dart';
import 'package:wazafak_app/components/category_chooser.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/components/working_hours_bottom_sheet.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/multiline_labeled_text_field.dart';
import '../../../../../utils/res/Resources.dart';
import 'add_service_controller.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
  );

  static const _cardShadow = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 8,
    spreadRadius: 0,
    offset: Offset(0, 0),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddServiceController());
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopHeader(
                hasBack: true,
                title: controller.isEditMode.value
                    ? context.resources.strings.editService
                    : context.resources.strings.addService,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),

                    // Card 1 — General Details
                    Container(
                      decoration: _cardDecoration.copyWith(
                        boxShadow: const [_cardShadow],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => LabeledTextFiled(
                                  controller: controller.titleController,
                                  hint: context.resources.strings.title,
                                  label: context.resources.strings.title,
                                  isMandatory: true,
                                  isPassword: false,
                                  inputType: TextInputType.text,
                                  enabled: !controller.isEditMode.value,
                                )),

                            Obx(() => MultilineLabeledTextField(
                                  controller: controller.descController,
                                  label:
                                      context.resources.strings.description,
                                  hint: context
                                      .resources.strings.enterYourDescription,
                                  maxLines: 20,
                                  height: 100,
                                  margin: 0,
                                  inputType: TextInputType.text,
                                  isPassword: false,
                                  isMandatory: true,
                                  enabled: !controller.isEditMode.value,
                                )),



                            // Category dropdown
                            Obx(() {
                              if (homeController.categories.isEmpty) {
                                return Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: ProgressBar()),
                                );
                              }
                              final selected =
                                  controller.selectedCategory.value;
                              final exists = selected != null &&
                                  homeController.categories.any(
                                      (c) => c.hashcode == selected.hashcode);
                              return CategoryChooser(
                                label: context.resources.strings.category,
                                text:
                                    context.resources.strings.selectCategory,
                                isMandatory: true,
                                withArrow: true,
                                list: homeController.categories,
                                selected: exists ? selected : null,
                                enabled: !controller.isEditMode.value,
                                onSelect: (category) {
                                  controller.selectCategory(category);
                                },
                              );
                            }),

                            // Subcategory chips
                            Obx(() {
                              if (controller.isLoadingSubcategories.value) {
                                return Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: ProgressBar()),
                                );
                              }
                              if (controller.subcategories.isEmpty) {
                                return SizedBox.shrink();
                              }
                              final selectedHashcode =
                                  controller.selectedSubcategory.value?.hashcode;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  SizedBox(
                                    height: 36,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          controller.subcategories.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(width: 8),
                                      itemBuilder: (context, index) {
                                        final sub =
                                            controller.subcategories[index];
                                        final isSelected =
                                            selectedHashcode == sub.hashcode;
                                        return GestureDetector(
                                          onTap: () {
                                            if (!controller.isEditMode.value) {
                                              controller
                                                  .selectSubcategory(sub);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? context.resources.color
                                                      .colorPrimary
                                                      .withAlpha(16)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: isSelected
                                                    ? context.resources.color
                                                        .colorPrimary
                                                    : context.resources.color
                                                        .colorGrey25,
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: PrimaryText(
                                                text: sub.name ?? '',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                textColor: isSelected
                                                    ? context.resources.color
                                                        .colorPrimary
                                                    : context.resources.color
                                                        .colorBlack4,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              );
                            }),


                            SizedBox(height: 12),

                            // Work location type chips
                            Obx(() {
                              const types = ['Onsite', 'Remote', 'Hybrid'];
                              final selected = controller.selectedWorkLocationType.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      PrimaryText(
                                        text: context.resources.strings.jobType,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        textColor: context.resources.color.colorGrey26,
                                      ),
                                      SizedBox(width: 4),
                                      PrimaryText(
                                        text: '*',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        textColor: context.resources.color.colorGrey26,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: 36,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: types.length,
                                      separatorBuilder: (_, __) => SizedBox(width: 8),
                                      itemBuilder: (context, index) {
                                        final type = types[index];
                                        final isSelected = selected == type;
                                        String label;
                                        switch (type) {
                                          case 'Remote': label = context.resources.strings.remote; break;
                                          case 'Hybrid': label = context.resources.strings.hybrid; break;
                                          default: label = context.resources.strings.onsite;
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            if (!controller.isEditMode.value) {
                                              controller.selectedWorkLocationType.value = type;
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? context.resources.color.colorPrimary.withAlpha(16)
                                                  : Colors.white,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: isSelected
                                                    ? context.resources.color.colorPrimary
                                                    : context.resources.color.colorGrey25,
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: PrimaryText(
                                                text: label,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                textColor: isSelected
                                                    ? context.resources.color.colorPrimary
                                                    : context.resources.color.colorBlack4,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              );
                            }),

                            Obx(() => AreaChooseWidget(
                              selectedAreas: controller.selectedAreas,
                              onAreasChanged: (areas) {
                                controller.selectedAreas.value = areas;
                              },
                              enabled: !controller.isEditMode.value,
                            )),

                            SizedBox(height: 12),

                            // Pricing type chips
                            Obx(() {
                              final selected =
                                  controller.selectedPricingType.value;
                              final options =
                                  controller.pricingTypeOptions;
                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text:
                                        "${context.resources.strings.pricingType} *",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    textColor: context
                                        .resources.color.colorGrey26,
                                  ),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: 36,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: options.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(width: 8),
                                      itemBuilder: (context, index) {
                                        final option = options[index];
                                        final isSelected =
                                            selected == option;
                                        return GestureDetector(
                                          onTap: () {
                                            if (!controller
                                                .isEditMode.value) {
                                              controller
                                                  .selectedPricingType
                                                  .value = option;
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? context.resources.color
                                                      .colorPrimary
                                                      .withAlpha(16)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: isSelected
                                                    ? context.resources.color
                                                        .colorPrimary
                                                    : context.resources.color
                                                        .colorGrey25,
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: PrimaryText(
                                                text: option,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                textColor: isSelected
                                                    ? context.resources.color
                                                        .colorPrimary
                                                    : context.resources.color
                                                        .colorBlack4,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                            SizedBox(height: 12),

                            Obx(() =>
                                controller.selectedPricingType.value ==
                                        Resources.of(Get.context!).strings
                                            .hourlyRateOption
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: LabeledTextFiled(
                                              controller: controller
                                                  .hourlyRateController,
                                              hint: context.resources.strings
                                                  .amountInUsd,
                                              label: context.resources.strings
                                                  .startingAt,
                                              isMandatory: true,
                                              isPassword: false,
                                              inputType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            margin: EdgeInsets.only(top: 24),
                                            child: PrimaryText(
                                              text: context
                                                  .resources.strings.perHour,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              textColor: context
                                                  .resources.color.colorGrey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : LabeledTextFiled(
                                        controller:
                                            controller.totalPriceController,
                                        hint: context
                                            .resources.strings.amountInUsd,
                                        label: context
                                            .resources.strings.startingAt,
                                        isMandatory: true,
                                        isPassword: false,
                                        inputType: TextInputType.number,
                                      )),

                            SizedBox(height: 8),

                            Obx(() => MultilineLabeledTextField(
                              controller:
                              controller.workExperienceController,
                              label: context
                                  .resources.strings.workExperience,
                              hint: context.resources.strings
                                  .briefDescriptionSuitableCandidate,
                              maxLines: 20,
                              height: 100,
                              margin: 0,
                              inputType: TextInputType.text,
                              isPassword: false,
                              isMandatory: true,
                              enabled: !controller.isEditMode.value,
                            )),

                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Card 2 — Skills
                    Obx(() {
                      if (controller.isLoadingSkills.value) {
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: _cardDecoration.copyWith(
                                boxShadow: const [_cardShadow],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PrimaryText(
                                      text: context.resources.strings.skills,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      textColor: context.resources.color.colorGrey26,
                                    ),
                                    SizedBox(height: 8),
                                    Center(child: ProgressBar()),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      }
                      if (controller.availableSkills.isEmpty) {
                        return SizedBox.shrink();
                      }
                      final selectedHashcodes = controller.selectedSkills
                          .map((s) => s.hashcode)
                          .toSet();
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: _cardDecoration.copyWith(
                              boxShadow: const [_cardShadow],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context.resources.strings.skills,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    textColor:
                                        context.resources.color.colorGrey26,
                                  ),
                                  SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: controller.availableSkills
                                        .map((skill) {
                                      final isSelected = selectedHashcodes
                                          .contains(skill.hashcode);
                                      return GestureDetector(
                                        onTap: () {
                                          if (!controller.isEditMode.value) {
                                            controller
                                                .toggleSkillSelection(skill);
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 7),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? context.resources.color
                                                    .colorPrimary
                                                    .withAlpha(16)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected
                                                  ? context.resources.color
                                                      .colorPrimary
                                                  : context.resources.color
                                                      .colorGrey29,
                                              width: 1,
                                            ),
                                          ),
                                          child: PrimaryText(
                                            text: skill.name ?? '',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            textColor: isSelected
                                                ? context
                                                    .resources.color.colorPrimary
                                                : context
                                                    .resources.color.colorGrey26,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    }),

                    // Card 3 — Experience & Availability
                    Container(
                      decoration: _cardDecoration.copyWith(
                        boxShadow: const [_cardShadow],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            PrimaryText(
                              text:
                                  "${context.resources.strings.workingHours}",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              textColor:
                                  context.resources.color.colorGrey26,
                            ),
                            SizedBox(height: 8),

                            GestureDetector(
                              onTap: () {
                                WorkingHoursBottomSheet.show(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorWhite,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        context.resources.color.colorGrey2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 20,
                                          color: Color(0xFFC6C6C6),
                                        ),
                                        SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            PrimaryText(
                                              text: context.resources.strings
                                                  .workingHours,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              textColor: context
                                                  .resources.color.colorPrimary,
                                            ),
                                            SizedBox(height: 4),
                                            Obx(() {
                                              final enabledDays = controller
                                                  .workingHours
                                                  .where((day) => day.isEnabled)
                                                  .length;
                                              return PrimaryText(
                                                text: context.resources.strings
                                                    .daysSelected(enabledDays),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                textColor: context
                                                    .resources.color.colorGrey,
                                              );
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color:
                                          context.resources.color.colorGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Card 4 — Portfolio File
                    Container(
                      decoration: _cardDecoration.copyWith(
                        boxShadow: const [_cardShadow],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: context.resources.strings.portfolio,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              textColor: context.resources.color.colorGrey26,
                            ),
                            SizedBox(height: 8),

                            GestureDetector(
                              onTap: () => controller.pickPortfolioFile(context),
                              child: DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  radius: Radius.circular(10),
                                  color: context.resources.color.colorGrey25,
                                  strokeWidth: 1.5,
                                  dashPattern: [6.0, 4.0],
                                  padding: EdgeInsets.zero,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'assets/images/upload.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 8),
                            PrimaryText(
                              text: context.resources.strings.maxFileSizeNote,
                              textColor: context.resources.color.colorGrey29,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),

                            Obx(() {
                              final hasLocalFile = controller.portfolioFile.value != null;
                              final hasUrlFile = controller.portfolioFileUrl.value != null;
                              if (!hasLocalFile && !hasUrlFile) return SizedBox.shrink();

                              final fileName = hasLocalFile
                                  ? (controller.portfolioFileName.value ?? '')
                                  : (controller.portfolioFileUrl.value!.split('/').last);

                              return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: Radius.circular(10),
                                    color: context.resources.color.colorPrimary,
                                    strokeWidth: 1.5,
                                    dashPattern: [6.0, 4.0],
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: context.resources.color.colorWhite,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: context.resources.color.colorPrimary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            controller.getPortfolioFileIcon(),
                                            color: context.resources.color.colorPrimary,
                                            size: 32,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              PrimaryText(
                                                text: fileName,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                textColor: context.resources.color.colorGrey,
                                                maxLines: 1,
                                              ),
                                              if (hasLocalFile && controller.portfolioFileSize.value != null) ...[
                                                SizedBox(height: 4),
                                                PrimaryText(
                                                  text: controller.getFormattedFileSize(controller.portfolioFileSize.value!),
                                                  fontSize: 12,
                                                  textColor: context.resources.color.colorGrey.withOpacity(0.7),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        if (!controller.isEditMode.value)
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: context.resources.color.colorPrimary,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              controller.removePortfolioFile();
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Obx(
                () => controller.isLoading.value
                    ? ProgressBar()
                    : PrimaryButton(
                        title: controller.isEditMode.value
                            ? context.resources.strings.updateService
                            : context.resources.strings.postService,
                        onPressed: () {
                          controller.addService();
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
