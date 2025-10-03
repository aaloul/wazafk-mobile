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
            TopHeader(hasBack: true, title: 'Add Service'),
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

                    SizedBox(height: 16),

                    AddressChooseWidget(),

                    SizedBox(height: 8),

                    Obx(
                      () => CategoryChooser(
                        label: 'Category',
                        text: 'Select Category',
                        isMandatory: true,
                        withArrow: true,
                        list: homeController.categories,
                        selected: controller.selectedCategory.value,
                        onSelect: (category) {
                          controller.selectCategory(category);
                        },
                      ),
                    ),
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

                    FileUploadItem(
                      label: 'Upload Portfolio',
                      isMandatory: false,
                      isOptional: false,
                      onClick: () {},
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
                      () => PrimaryChooser(
                        label: 'Duration',
                        text: 'Select Duration',
                        isMandatory: true,
                        withArrow: true,
                        isMultiSelect: false,
                        list: controller.durationOptions,
                        selected: controller.selectedDuration.value,
                        onSelect: (value) {
                          controller.selectDuration(value);
                        },
                      ),
                    ),

                    Obx(
                      () => PrimaryChooser(
                        label: 'Buffer Time',
                        text: 'Select Buffer Time',
                        isMandatory: true,
                        withArrow: true,
                        isMultiSelect: false,
                        list: controller.bufferTimeOptions,
                        selected: controller.selectedBufferTime.value,
                        onSelect: (value) {
                          controller.selectBufferTime(value);
                        },
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
                        title: 'Save Service',
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
