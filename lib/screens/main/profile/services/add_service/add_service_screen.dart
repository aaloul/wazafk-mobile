import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/category_chooser.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/components/address_choose_widget.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/components/skills_choose_widget.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/components/working_hours_bottom_sheet.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/multiline_labeled_text_field.dart';
import '../../../../../components/primary_chooser.dart';
import '../../../../../utils/res/Resources.dart';
import 'add_service_controller.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddServiceController());
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: context.resources.color.background,
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

                    PrimaryText(
                      text: "${context.resources.strings.generalDetails} *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    SizedBox(height: 16),

                    LabeledTextFiled(
                      controller: controller.titleController,
                      hint: context.resources.strings.title,
                      label: context.resources.strings.title,
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),

                    MultilineLabeledTextField(
                      controller: controller.descController,
                      label: context.resources.strings.description,
                      hint: context.resources.strings.enterYourDescription,
                      maxLines: 20,
                      height: 100,
                      margin: 0,
                      inputType: TextInputType.text,
                      isPassword: false,
                      isMandatory: true,
                    ),

                    SizedBox(height: 12),

                    AddressChooseWidget(),

                    SizedBox(height: 8),

                    Obx(() {
                      // Don't render if list is empty
                      if (homeController.categories.isEmpty) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: ProgressBar()),
                        );
                      }

                      // Only pass selected if it exists in the list
                      final selected = controller.selectedCategory.value;
                      final exists =
                          selected != null &&
                          homeController.categories.any(
                            (c) => c.hashcode == selected.hashcode,
                          );

                      return CategoryChooser(
                        label: context.resources.strings.category,
                        text: context.resources.strings.selectCategory,
                        isMandatory: true,
                        withArrow: true,
                        list: homeController.categories,
                        selected: exists ? selected : null,
                        onSelect: (category) {
                          controller.selectCategory(category);
                        },
                      );
                    }),

                    Obx(
                      () => controller.isLoadingSubcategories.value
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: ProgressBar()),
                            )
                          : controller.subcategories.isNotEmpty
                          ? Column(
                              children: [
                                Builder(
                                  builder: (context) {
                                    // Only pass selected if it exists in the list
                                    final selected =
                                        controller.selectedSubcategory.value;
                                    final exists =
                                        selected != null &&
                                        controller.subcategories.any(
                                          (c) =>
                                              c.hashcode == selected.hashcode,
                                        );

                                    return CategoryChooser(
                                      label:
                                          context.resources.strings.subcategory,
                                      text: context
                                          .resources
                                          .strings
                                          .selectSubcategory,
                                      isMandatory: true,
                                      withArrow: true,
                                      list: controller.subcategories,
                                      selected: exists ? selected : null,
                                      onSelect: (subcategory) {
                                        controller.selectSubcategory(
                                          subcategory,
                                        );
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 12),
                              ],
                            )
                          : SizedBox.shrink(),
                    ),

                    Obx(
                      () => PrimaryChooser(
                        label: context.resources.strings.pricingType,
                        text: context.resources.strings.pricingType,
                        isMandatory: true,
                        withArrow: true,
                        isMultiSelect: false,
                        list: controller.pricingTypeOptions,
                        selected:
                            controller.selectedPricingType.value.isNotEmpty
                            ? controller.selectedPricingType.value
                            : null,
                        onSelect: (value) {
                          controller.selectedPricingType.value = value;
                        },
                      ),
                    ),
                    SizedBox(height: 12),

                    Obx(
                      () =>
                          controller.selectedPricingType.value ==
                              Resources.of(
                                Get.context!,
                              ).strings.hourlyRateOption
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryText(
                                  text:
                                      "${context.resources.strings.hourlyRate} *",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 8),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: LabeledTextFiled(
                                        controller:
                                            controller.hourlyRateController,
                                        hint: context
                                            .resources
                                            .strings
                                            .amountInUsd,
                                        label: context
                                            .resources
                                            .strings
                                            .startingAt,
                                        isMandatory: true,
                                        isPassword: false,
                                        inputType: TextInputType.number,
                                      ),
                                    ),

                                    SizedBox(width: 8),
                                    Container(
                                      margin: EdgeInsets.only(top: 24),
                                      child: PrimaryText(
                                        text: context.resources.strings.perHour,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        textColor:
                                            context.resources.color.colorGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryText(
                                  text:
                                      "${context.resources.strings.totalPrice} *",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 8),
                                LabeledTextFiled(
                                  controller:
                                  controller.totalPriceController,
                                  hint: context
                                      .resources
                                      .strings
                                      .amountInUsd,
                                  label: context
                                      .resources
                                      .strings
                                      .startingAt,
                                  isMandatory: true,
                                  isPassword: false,
                                  inputType: TextInputType.number,
                                ),
                              ],
                            ),
                    ),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "${context.resources.strings.workExperience} *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    MultilineLabeledTextField(
                      controller: controller.workExperienceController,
                      label: context.resources.strings.enterYourExperience,
                      hint: context
                          .resources
                          .strings
                          .briefDescriptionSuitableCandidate,
                      maxLines: 20,
                      height: 100,
                      margin: 0,
                      inputType: TextInputType.text,
                      isPassword: false,
                      isMandatory: true,
                    ),

                    SizedBox(height: 16),

                    SkillsChooseWidget(),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "${context.resources.strings.workingHours} *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    SizedBox(height: 16),

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
                            color: context.resources.color.colorGrey8,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: context.resources.color.colorGrey,
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PrimaryText(
                                      text: context
                                          .resources
                                          .strings
                                          .workingHours,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      textColor:
                                          context.resources.color.colorPrimary,
                                    ),
                                    SizedBox(height: 4),
                                    Obx(() {
                                      final enabledDays = controller
                                          .workingHours
                                          .where((day) => day.isEnabled)
                                          .length;
                                      return PrimaryText(
                                        text: context.resources.strings.daysSelected(enabledDays),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        textColor:
                                            context.resources.color.colorGrey,
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                        Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: context.resources.color.colorGrey,
                            
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),
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
                            : context.resources.strings.saveService,
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
