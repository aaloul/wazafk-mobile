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
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
              hasBack: true,
              title: controller.isEditMode ? context.resources.strings.editJobPost : context.resources.strings.addJobPost,
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE5E5E5), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        LabeledTextFiled(
                          controller: controller.titleController,
                          hint: context.resources.strings.title,
                          label: context.resources.strings.title,
                          isMandatory: true,
                          isPassword: false,
                          inputType: TextInputType.text,
                          enabled: !controller.isEditMode,
                        ),


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
                              label: context.resources.strings.category,
                              text: context.resources.strings.selectCategory,
                              isMandatory: true,
                              withArrow: true,
                              list: homeController.jobCategories,
                              selected: controller.selectedCategory.value,
                              enabled: !controller.isEditMode,
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
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: ProgressBar()),
                            );
                          }
                          if (controller.subcategories.isEmpty) return SizedBox.shrink();
                          final selectedHashcode = controller.selectedSubcategory.value?.hashcode;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),

                              SizedBox(
                                height: 36,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.subcategories.length,
                                  separatorBuilder: (_, __) => SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final sub = controller.subcategories[index];
                                    final isSelected = selectedHashcode == sub.hashcode;
                                    return GestureDetector(
                                      onTap: () {
                                        if (!(controller.isEditMode)) {
                                          controller.selectSubcategory(sub);
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
                                            text: sub.name ?? '',
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

                        

                        SizedBox(height: 8),

                        JobTypeRadioWidget(enabled: !controller.isEditMode),

                        SizedBox(height: 12),

                        JobAddressChooseWidget(enabled: !controller.isEditMode),

                        SizedBox(height: 16),

                        PrimaryText(
                          text: "${context.resources.strings.startDate} *",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey26,
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
                                        text: context
                                            .resources
                                            .strings
                                            .selectDateRange,
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
                                          : context.resources.strings.selectDate,
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
                                    color: Color(0xFFC6C6C6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        PrimaryText(
                          text: "${context.resources.strings.startTime} *",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey26,
                        ),
                        SizedBox(height: 8),

                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showModalBottomSheet<TimeOfDay>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                final current = controller.selectedTime.value ?? TimeOfDay.now();
                                bool isPM = current.period == DayPeriod.pm;
                                int selectedHour = current.hourOfPeriod == 0 ? 12 : current.hourOfPeriod;
                                int selectedMinute = current.minute;
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: context.resources.color.colorWhite,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 28),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: PrimaryText(
                                                text: context.resources.strings.setTime,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                textColor: context.resources.color.colorBlack4,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          SizedBox(
                                            height: 120,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                SizedBox(
                                                  width: 70,
                                                  child: ListWheelScrollView.useDelegate(
                                                    itemExtent: 40,
                                                    perspective: 0.005,
                                                    diameterRatio: 1.2,
                                                    physics: FixedExtentScrollPhysics(),
                                                    controller: FixedExtentScrollController(initialItem: selectedHour - 1),
                                                    onSelectedItemChanged: (i) => setState(() => selectedHour = i + 1),
                                                    childDelegate: ListWheelChildBuilderDelegate(
                                                      childCount: 12,
                                                      builder: (context, i) {
                                                        final h = i + 1;
                                                        return Center(
                                                          child: PrimaryText(
                                                            text: h.toString().padLeft(2, '0'),
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            textColor: selectedHour == h
                                                                ? context.resources.color.colorBlack4
                                                                : context.resources.color.colorGrey,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                PrimaryText(text: ':', fontSize: 24, fontWeight: FontWeight.w600, textColor: context.resources.color.colorBlack4),
                                                SizedBox(
                                                  width: 70,
                                                  child: ListWheelScrollView.useDelegate(
                                                    itemExtent: 40,
                                                    perspective: 0.005,
                                                    diameterRatio: 1.2,
                                                    physics: FixedExtentScrollPhysics(),
                                                    controller: FixedExtentScrollController(initialItem: selectedMinute),
                                                    onSelectedItemChanged: (i) => setState(() => selectedMinute = i),
                                                    childDelegate: ListWheelChildBuilderDelegate(
                                                      childCount: 60,
                                                      builder: (context, i) => Center(
                                                        child: PrimaryText(
                                                          text: i.toString().padLeft(2, '0'),
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w600,
                                                          textColor: selectedMinute == i
                                                              ? context.resources.color.colorBlack4
                                                              : context.resources.color.colorGrey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                SizedBox(
                                                  width: 60,
                                                  child: ListWheelScrollView.useDelegate(
                                                    itemExtent: 40,
                                                    perspective: 0.005,
                                                    diameterRatio: 1.2,
                                                    physics: FixedExtentScrollPhysics(),
                                                    controller: FixedExtentScrollController(initialItem: isPM ? 1 : 0),
                                                    onSelectedItemChanged: (i) => setState(() => isPM = i == 1),
                                                    childDelegate: ListWheelChildBuilderDelegate(
                                                      childCount: 2,
                                                      builder: (context, i) {
                                                        final isSelected = (i == 0 && !isPM) || (i == 1 && isPM);
                                                        return Center(
                                                          child: PrimaryText(
                                                            text: i == 0 ? 'AM' : 'PM',
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                            textColor: isSelected
                                                                ? context.resources.color.colorBlack4
                                                                : context.resources.color.colorGrey,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                  ],
                                                ),
                                                IgnorePointer(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Container(height: 1, color: Color(0xFFE5E5E5)),
                                                      SizedBox(height: 38),
                                                      Container(height: 1, color: Color(0xFFE5E5E5)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      int hour24 = selectedHour == 12
                                                          ? (isPM ? 12 : 0)
                                                          : (isPM ? selectedHour + 12 : selectedHour);
                                                      Navigator.pop(context, TimeOfDay(hour: hour24, minute: selectedMinute));
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: context.resources.color.colorPrimary,
                                                      padding: EdgeInsets.symmetric(vertical: 12),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    ),
                                                    child: PrimaryText(
                                                      text: context.resources.strings.save,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      textColor: context.resources.color.colorWhite,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(vertical: 12),
                                                      side: BorderSide(color: context.resources.color.colorGrey25),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    ),
                                                    child: PrimaryText(
                                                      text: context.resources.strings.cancel,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      textColor: context.resources.color.colorGrey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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
                                          : context.resources.strings.selectTime,
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
                                    color: Color(0xFFC6C6C6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        PrimaryText(
                          text: context.resources.strings.expiryDate,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey26,
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
                                        text: context
                                            .resources
                                            .strings
                                            .selectExpiryDate,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        textColor:
                                        context.resources.color.colorGrey,
                                      ),
                                      Expanded(
                                        child: CalendarDatePicker(
                                          initialDate:
                                          controller.selectedExpiryDate.value ??
                                              DateTime.now().add(
                                                Duration(days: 30),
                                              ),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(
                                            Duration(days: 365),
                                          ),
                                          onDateChanged: (DateTime date) {
                                            controller.selectExpiryDate(date);
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
                                      text:
                                      controller.selectedExpiryDate.value !=
                                          null
                                          ? DateFormat('MMM dd, yyyy').format(
                                        controller.selectedExpiryDate.value!,
                                      )
                                          : context.resources.strings.selectExpiryDate,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textColor:
                                      controller.selectedExpiryDate.value !=
                                          null
                                          ? context.resources.color.colorGrey
                                          : context.resources.color.colorGrey8,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Color(0xFFC6C6C6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        PrimaryText(
                          text: context.resources.strings.expiryTime,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey26,
                        ),
                        SizedBox(height: 8),

                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showModalBottomSheet<TimeOfDay>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                final current = controller.selectedExpiryTime.value ?? TimeOfDay.now();
                                bool isPM = current.period == DayPeriod.pm;
                                int selectedHour = current.hourOfPeriod == 0 ? 12 : current.hourOfPeriod;
                                int selectedMinute = current.minute;
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: context.resources.color.colorWhite,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 16),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: PrimaryText(
                                                text: context.resources.strings.setTime,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                textColor: context.resources.color.colorBlack4,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          SizedBox(
                                            height: 120,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                SizedBox(
                                                  width: 70,
                                                  child: ListWheelScrollView.useDelegate(
                                                    itemExtent: 40,
                                                    perspective: 0.005,
                                                    diameterRatio: 1.2,
                                                    physics: FixedExtentScrollPhysics(),
                                                    controller: FixedExtentScrollController(initialItem: selectedHour - 1),
                                                    onSelectedItemChanged: (i) => setState(() => selectedHour = i + 1),
                                                    childDelegate: ListWheelChildBuilderDelegate(
                                                      childCount: 12,
                                                      builder: (context, i) {
                                                        final h = i + 1;
                                                        return Center(
                                                          child: PrimaryText(
                                                            text: h.toString().padLeft(2, '0'),
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            textColor: selectedHour == h
                                                                ? context.resources.color.colorBlack4
                                                                : context.resources.color.colorGrey,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                PrimaryText(text: ':', fontSize: 24, fontWeight: FontWeight.w600, textColor: context.resources.color.colorBlack4),
                                                SizedBox(
                                                  width: 70,
                                                  child: ListWheelScrollView.useDelegate(
                                                    itemExtent: 40,
                                                    perspective: 0.005,
                                                    diameterRatio: 1.2,
                                                    physics: FixedExtentScrollPhysics(),
                                                    controller: FixedExtentScrollController(initialItem: selectedMinute),
                                                    onSelectedItemChanged: (i) => setState(() => selectedMinute = i),
                                                    childDelegate: ListWheelChildBuilderDelegate(
                                                      childCount: 60,
                                                      builder: (context, i) => Center(
                                                        child: PrimaryText(
                                                          text: i.toString().padLeft(2, '0'),
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w600,
                                                          textColor: selectedMinute == i
                                                              ? context.resources.color.colorBlack4
                                                              : context.resources.color.colorGrey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                SizedBox(
                                                  width: 60,
                                                  child: ListWheelScrollView.useDelegate(
                                                    itemExtent: 40,
                                                    perspective: 0.005,
                                                    diameterRatio: 1.2,
                                                    physics: FixedExtentScrollPhysics(),
                                                    controller: FixedExtentScrollController(initialItem: isPM ? 1 : 0),
                                                    onSelectedItemChanged: (i) => setState(() => isPM = i == 1),
                                                    childDelegate: ListWheelChildBuilderDelegate(
                                                      childCount: 2,
                                                      builder: (context, i) {
                                                        final isSelected = (i == 0 && !isPM) || (i == 1 && isPM);
                                                        return Center(
                                                          child: PrimaryText(
                                                            text: i == 0 ? 'AM' : 'PM',
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                            textColor: isSelected
                                                                ? context.resources.color.colorBlack4
                                                                : context.resources.color.colorGrey,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                  ],
                                                ),
                                                IgnorePointer(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Container(height: 1, color: Color(0xFFE5E5E5)),
                                                      SizedBox(height: 38),
                                                      Container(height: 1, color: Color(0xFFE5E5E5)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      int hour24 = selectedHour == 12
                                                          ? (isPM ? 12 : 0)
                                                          : (isPM ? selectedHour + 12 : selectedHour);
                                                      Navigator.pop(context, TimeOfDay(hour: hour24, minute: selectedMinute));
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: context.resources.color.colorPrimary,
                                                      padding: EdgeInsets.symmetric(vertical: 12),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    ),
                                                    child: PrimaryText(
                                                      text: context.resources.strings.save,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      textColor: context.resources.color.colorWhite,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(vertical: 12),
                                                      side: BorderSide(color: context.resources.color.colorGrey25),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    ),
                                                    child: PrimaryText(
                                                      text: context.resources.strings.cancel,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      textColor: context.resources.color.colorGrey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                            if (picked != null) {
                              controller.selectExpiryTime(picked);
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
                                      text:
                                      controller.selectedExpiryTime.value !=
                                          null
                                          ? controller.selectedExpiryTime.value!
                                          .format(context)
                                          : context.resources.strings.selectExpiryTime,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textColor:
                                      controller.selectedExpiryTime.value !=
                                          null
                                          ? context.resources.color.colorGrey
                                          : context.resources.color.colorGrey8,
                                    ),
                                  ),
                                  Icon(
                                    Icons.access_time,
                                    size: 20,
                                    color: Color(0xFFC6C6C6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),


                        SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: LabeledTextFiled(
                                controller: controller.totalPriceController,
                                hint: context.resources.strings.amountInUsd,
                                label: context.resources.strings.jobRate,
                                isMandatory: true,
                                isPassword: false,
                                inputType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, bottom: 12),
                              child: PrimaryText(
                                text: context.resources.strings.perJob,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textColor: context.resources.color.colorGrey,
                              ),
                            ),
                          ],
                        ),

                      ],
                    )
                    )
                    ),


                    SizedBox(height: 16),


                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFE5E5E5), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 16),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            PrimaryText(
                              text: context.resources.strings.jobDetails,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              textColor: context.resources.color.colorBlack4,
                            ),

                            SizedBox(height: 16),


                            JobSkillsChooseWidget(enabled: !controller.isEditMode),



                            MultilineLabeledTextField(
                              controller: controller.overviewController,
                              label: context.resources.strings.overview,
                              hint: context.resources.strings.briefDescription,
                              maxLines: 20,
                              height: 100,
                              margin: 0,
                              inputType: TextInputType.text,
                              isPassword: false,
                              isMandatory: true,
                              enabled: !controller.isEditMode,
                            ),

                            SizedBox(height: 8),

                            MultilineLabeledTextField(
                              controller: controller.responsibilitiesController,
                              label: context.resources.strings.responsibilities,
                              hint: context.resources.strings.listKeyResponsibilities,
                              maxLines: 20,
                              height: 100,
                              margin: 0,
                              inputType: TextInputType.text,
                              isPassword: false,
                              isMandatory: true,
                              enabled: !controller.isEditMode,
                            ),

                            SizedBox(height: 8),

                            MultilineLabeledTextField(
                              controller: controller.requirementsController,
                              label: context.resources.strings.requirements,
                              hint: context.resources.strings.listRequiredSkillsQualifications,
                              maxLines: 20,
                              height: 100,
                              margin: 0,
                              inputType: TextInputType.text,
                              isPassword: false,
                              isMandatory: true,
                              enabled: !controller.isEditMode,
                            ),


                            ]))),




                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => controller.isLoading.value
                    ? ProgressBar()
                    : PrimaryButton(
                        title: controller.isEditMode
                            ? context.resources.strings.updateJob
                            : context.resources.strings.postJob,
                        onPressed: () {
                          controller.addJob();
                        },
                      ),
              ),
            ),
            SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
