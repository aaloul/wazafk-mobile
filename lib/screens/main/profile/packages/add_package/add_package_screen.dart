import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/file_upload_item.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_chooser.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/profile/packages/add_package/add_package_controller.dart';
import 'package:wazafak_app/screens/main/profile/packages/add_package/components/package_working_hours_bottom_sheet.dart';
import 'package:wazafak_app/screens/main/profile/packages/add_package/components/services_selection_bottom_sheet.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class AddPackageScreen extends StatelessWidget {
  const AddPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPackageController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopHeader(
                hasBack: true,
                title: controller.isEditMode.value
                    ? 'Edit Package'
                    : 'Add Package',
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
                      hint: 'Enter Package Description',
                      maxLines: 20,
                      height: 100,
                      margin: 0,
                      inputType: TextInputType.text,
                      isPassword: false,
                      isMandatory: true,
                    ),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "Services",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        ServicesSelectionBottomSheet.show(context);
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
                                  Icons.list_alt,
                                  size: 20,
                                  color: context.resources.color.colorGrey,
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PrimaryText(
                                      text: "Select Services",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      textColor:
                                          context.resources.color.colorPrimary,
                                    ),
                                    SizedBox(height: 4),
                                    Obx(() {
                                      final selectedCount =
                                          controller.selectedServices.length;
                                      return PrimaryText(
                                        text: selectedCount > 0
                                            ? '$selectedCount service(s) selected'
                                            : 'No services selected',
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

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "Price *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    SizedBox(height: 8),

                    LabeledTextFiled(
                      controller: controller.unitPriceController,
                      hint: 'Unit Price',
                      label: 'Unit Price',
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.number,
                    ),

                    LabeledTextFiled(
                      controller: controller.totalPriceController,
                      hint: 'Total Price',
                      label: 'Total Price',
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.number,
                    ),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "Availability *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),

                    SizedBox(height: 8),

                    Obx(() {
                      final selected = controller.selectedDuration.value;
                      final exists = controller.durationOptions.contains(
                        selected,
                      );

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
                    }),

                    Obx(() {
                      final selected = controller.selectedBufferTime.value;
                      final exists = controller.bufferTimeOptions.contains(
                        selected,
                      );

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
                    }),

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
                        PackageWorkingHoursBottomSheet.show(context);
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
                                        text: '$enabledDays days selected',
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
                    SizedBox(height: 16),

                    PrimaryText(
                      text: "Cover Image*",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),

                    SizedBox(height: 8),

                    Obx(() {
                      final hasLocalImage =
                          controller.packageImage.value != null;
                      final hasUrlImage =
                          controller.packageImageUrl.value != null;

                      if (hasUrlImage || hasLocalImage) {
                        return Container();
                      }

                      return FileUploadItem(
                        label:
                            controller.packageImage.value != null ||
                                controller.packageImageUrl.value != null
                            ? 'Image Selected'
                            : 'Upload Image',
                        isMandatory: false,
                        isOptional: false,
                        onClick: () {
                          controller.pickPackageImage();
                        },
                      );
                    }),

                    // Show selected image (local file or URL)
                    Obx(() {
                      final hasLocalImage =
                          controller.packageImage.value != null;
                      final hasUrlImage =
                          controller.packageImageUrl.value != null;

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
                                      controller.packageImage.value!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : PrimaryNetworkImage(
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      url: controller.packageImageUrl.value!,
                                    ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  controller.removePackageImage();
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
                                    color: context.resources.color.colorPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

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
                            ? 'Update Package'
                            : 'Save Package',
                        onPressed: () {
                          controller.addPackage();
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
