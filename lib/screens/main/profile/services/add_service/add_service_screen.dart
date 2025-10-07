import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/category_chooser.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/components/address_choose_widget.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/components/skills_choose_widget.dart';
import 'package:wazafak_app/screens/main/profile/services/add_service/select_service_working_hours/select_service_working_hours_screen.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/file_upload_item.dart';
import '../../../../../components/multiline_labeled_text_field.dart';
import '../../../../../components/primary_chooser.dart';
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
                    ? 'Edit Service'
                    : 'Add Service',
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
                      text: "General Details *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    SizedBox(height: 16),

                    LabeledTextFiled(
                      controller: controller.titleController,
                      hint: 'Title',
                      label: 'Title',
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),

                    MultilineLabeledTextField(
                      controller: controller.descController,
                      label: 'Description',
                      hint: 'Enter Your Description',
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
                        label: 'Category',
                        text: 'Select Category',
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
                                      label: 'Subcategory',
                                      text: 'Select Subcategory',
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
                    SizedBox(height: 12),

                    PrimaryText(
                      text: "Hourly Rate *",
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
                            controller: controller.hourlyRateController,
                            hint: 'Amount in USD',
                            label: 'Hourly Rate',
                            isMandatory: true,
                            isPassword: false,
                            inputType: TextInputType.number,
                          ),
                        ),

                        SizedBox(width: 8),
                        Container(
                          margin: EdgeInsets.only(top: 24),
                          child: PrimaryText(
                            text: "/ Hour",
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            textColor: context.resources.color.colorGrey,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "Work Experience *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    MultilineLabeledTextField(
                      controller: controller.workExperienceController,
                      label: 'Enter Your Experience',
                      hint:
                          'Brief Description of why you are a suitable candidate for this job',
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
                      text: "Portfolio",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),

                    SizedBox(height: 8),

                    Obx(
                          () =>
                          FileUploadItem(
                            label: controller.portfolioImage.value != null ||
                                controller.portfolioImageUrl.value != null
                                ? 'Portfolio Selected'
                                : 'Upload Portfolio',
                            isMandatory: false,
                            isOptional: false,
                            onClick: () {
                              controller.pickPortfolioImage();
                            },
                          ),
                    ),

                    // Show selected image (local file or URL)
                    Obx(
                          () {
                        final hasLocalImage = controller.portfolioImage.value !=
                            null;
                        final hasUrlImage = controller.portfolioImageUrl
                            .value != null;

                        if (!hasLocalImage && !hasUrlImage) {
                          return SizedBox.shrink();
                        }

                        return Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: hasLocalImage
                                    ? Image.file(
                                  controller.portfolioImage.value!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                                    : Image.network(
                                  controller.portfolioImageUrl.value!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 150,
                                      color: context.resources.color.colorGrey8,
                                      child: Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          color: context.resources.color
                                              .colorGrey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.removePortfolioImage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: context.resources.color.colorWhite,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: context.resources.color
                                          .colorPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "Availability *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),

                    SizedBox(height: 8),

                    Obx(
                          () {
                        // Only pass selected if it exists in the list
                        final selected = controller.selectedDuration.value;
                        final exists = controller.durationOptions.contains(
                            selected);

                        return PrimaryChooser(
                          label: 'Duration',
                          text: 'Select Duration',
                          isMandatory: true,
                          withArrow: true,
                          isMultiSelect: false,
                          list: controller.durationOptions,
                          selected: exists ? selected : null,
                          onSelect: (value) {
                            controller.selectDuration(value);
                          },
                        );
                      },
                    ),

                    Obx(
                          () {
                        // Only pass selected if it exists in the list
                        final selected = controller.selectedBufferTime.value;
                        final exists = controller.bufferTimeOptions.contains(
                            selected);

                        return PrimaryChooser(
                          label: 'Buffer Time',
                          text: 'Select Buffer Time',
                          isMandatory: true,
                          withArrow: true,
                          isMultiSelect: false,
                          list: controller.bufferTimeOptions,
                          selected: exists ? selected : null,
                          onSelect: (value) {
                            controller.selectBufferTime(value);
                          },
                        );
                      },
                    ),

                    SizedBox(height: 12),

                    PrimaryText(
                      text: "Working Hours *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SelectServiceWorkingHoursScreen());
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
                                      text: "Working Hours",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      textColor: context.resources.color
                                          .colorPrimary,
                                    ),
                                    SizedBox(height: 4),
                                    Obx(
                                          () {
                                        final enabledDays = controller
                                            .workingHours
                                            .where((day) => day.isEnabled)
                                            .length;
                                        return PrimaryText(
                                          text: '$enabledDays days selected',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          textColor: context.resources.color
                                              .colorGrey,
                                        );
                                      },
                                    ),
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
                      ? 'Update Service'
                      : 'Save Service',
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
