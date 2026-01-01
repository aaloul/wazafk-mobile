import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/file_upload_item.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
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
                    ? context.resources.strings.editPackage
                    : context.resources.strings.addPackage,
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
                      text: "${context.resources.strings.generalDetails}",
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
                      hint: context.resources.strings.enterPackageDescription,
                      maxLines: 20,
                      height: 100,
                      margin: 0,
                      inputType: TextInputType.text,
                      isPassword: false,
                      isMandatory: true,
                    ),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: context.resources.strings.services,
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
                                      text: context
                                          .resources
                                          .strings
                                          .selectServices,
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
                                            ? context.resources.strings.servicesSelected(selectedCount)
                                            : context.resources.strings.noServicesSelected,
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
                      text: "${context.resources.strings.price} *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),
                    SizedBox(height: 8),

                    // LabeledTextFiled(
                    //   controller: controller.unitPriceController,
                    //   hint: context.resources.strings.unitPrice,
                    //   label: context.resources.strings.unitPrice,
                    //   isMandatory: true,
                    //   isPassword: false,
                    //   inputType: TextInputType.number,
                    // ),

                    LabeledTextFiled(
                      controller: controller.totalPriceController,
                      hint: context.resources.strings.totalPrice,
                      label: context.resources.strings.totalPrice,
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.number,
                    ),

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
                    SizedBox(height: 16),

                    PrimaryText(
                      text: "${context.resources.strings.coverImage}",
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
                            ? context.resources.strings.imageSelected
                            : context.resources.strings.uploadImage,
                        isMandatory: false,
                        isOptional: false,
                        onClick: () {
                          controller.pickPackageImage(context);
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
                            ? context.resources.strings.updatePackage
                            : context.resources.strings.savePackage,
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
