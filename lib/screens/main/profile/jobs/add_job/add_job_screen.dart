import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/category_chooser.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'add_job_controller.dart';
import 'components/job_address_choose_widget.dart';
import 'components/job_skills_choose_widget.dart';
import 'components/job_type_radio_widget.dart';

class AddJobScreen extends StatelessWidget {
  const AddJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddJobController());
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Add Job Post'),
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

                    SizedBox(height: 8),

                    JobAddressChooseWidget(),

                    SizedBox(height: 8),

                    Obx(() {
                      // Show loading indicator while categories are being fetched
                      if (homeController.isLoadingJobCategories.value ||
                          homeController.jobCategories.isEmpty) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: ProgressBar()),
                        );
                      }

                      return Obx(
                        () => CategoryChooser(
                          label: 'Category',
                          text: 'Select Category',
                          isMandatory: true,
                          withArrow: true,
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

                    Obx(
                      () => controller.isLoadingSubcategories.value
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: ProgressBar()),
                            )
                          : controller.subcategories.isNotEmpty
                          ? Column(
                              children: [
                                CategoryChooser(
                                  label: 'Subcategory',
                                  text: 'Select Subcategory',
                                  isMandatory: true,
                                  withArrow: true,
                                  list: controller.subcategories,
                                  selected:
                                      controller.selectedSubcategory.value,
                                  onSelect: (subcategory) {
                                    if (subcategory != null) {
                                      controller.selectSubcategory(subcategory);
                                    }
                                  },
                                ),
                                SizedBox(height: 12),
                              ],
                            )
                          : SizedBox.shrink(),
                    ),

                    SizedBox(height: 12),

                    JobTypeRadioWidget(),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "Start Date *",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey3,
                    ),
                    SizedBox(height: 8),

                    GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Container(
                              height: 400,
                              decoration: BoxDecoration(
                                color: context.resources.color.colorWhite,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 16),
                                  PrimaryText(
                                    text: 'Select Date',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                  Expanded(
                                    child: CalendarDatePicker(
                                      initialDate:
                                          controller.selectedDate.value ??
                                          DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        Duration(days: 365),
                                      ),
                                      onDateChanged: (DateTime date) {
                                        controller.selectDate(date);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: context.resources.color.colorWhite,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: context.resources.color.colorGrey2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: PrimaryText(
                                  text: controller.selectedDate.value != null
                                      ? DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(controller.selectedDate.value!)
                                      : 'Select Date',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor:
                                      controller.selectedDate.value != null
                                      ? context.resources.color.colorGrey
                                      : context.resources.color.colorGrey8,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: context.resources.color.colorGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    PrimaryText(
                      text: "Start Time *",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey3,
                    ),
                    SizedBox(height: 8),

                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay?
                        picked = await showModalBottomSheet<TimeOfDay>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Container(
                              height: 450,
                              decoration: BoxDecoration(
                                color: context.resources.color.colorWhite,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: PrimaryText(
                                            text: 'Cancel',
                                            fontSize: 16,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey,
                                          ),
                                        ),
                                        PrimaryText(
                                          text: 'Select Time',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                              controller.selectedTime.value ??
                                                  TimeOfDay.now(),
                                            );
                                          },
                                          child: PrimaryText(
                                            text: 'Done',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        timePickerTheme: TimePickerThemeData(
                                          dialHandColor: context
                                              .resources
                                              .color
                                              .colorPrimary,
                                          dialBackgroundColor: context
                                              .resources
                                              .color
                                              .colorGrey9,
                                        ),
                                      ),
                                      child: TimePickerDialog(
                                        initialTime:
                                            controller.selectedTime.value ??
                                            TimeOfDay.now(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        if (picked != null) {
                          controller.selectTime(picked);
                        }
                      },
                      child: Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: context.resources.color.colorWhite,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: context.resources.color.colorGrey2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: PrimaryText(
                                  text: controller.selectedTime.value != null
                                      ? controller.selectedTime.value!.format(
                                          context,
                                        )
                                      : 'Select Time',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor:
                                      controller.selectedTime.value != null
                                      ? context.resources.color.colorGrey
                                      : context.resources.color.colorGrey8,
                                ),
                              ),
                              Icon(
                                Icons.access_time,
                                size: 20,
                                color: context.resources.color.colorGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

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

                    JobSkillsChooseWidget(),

                    SizedBox(height: 16),

                    PrimaryText(
                      text: "Job Details *",
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textColor: context.resources.color.colorGrey,
                    ),

                    MultilineLabeledTextField(
                      controller: controller.overviewController,
                      label: 'Overview',
                      hint: 'Brief description of the job',
                      maxLines: 20,
                      height: 100,
                      margin: 0,
                      inputType: TextInputType.text,
                      isPassword: false,
                      isMandatory: true,
                    ),

                    SizedBox(height: 8),

                    MultilineLabeledTextField(
                      controller: controller.responsibilitiesController,
                      label: 'Responsibilities',
                      hint: 'List the key responsibilities',
                      maxLines: 20,
                      height: 100,
                      margin: 0,
                      inputType: TextInputType.text,
                      isPassword: false,
                      isMandatory: true,
                    ),

                    SizedBox(height: 8),

                    MultilineLabeledTextField(
                      controller: controller.requirementsController,
                      label: 'Requirements',
                      hint: 'List the required skills and qualifications',
                      maxLines: 20,
                      height: 100,
                      margin: 0,
                      inputType: TextInputType.text,
                      isPassword: false,
                      isMandatory: true,
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
                        title: 'Post Job',
                        onPressed: () {
                          controller.addJob();
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
