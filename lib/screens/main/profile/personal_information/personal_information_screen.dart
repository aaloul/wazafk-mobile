import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/date_chooser.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_chooser.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'personal_information_controller.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalInformationController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Personal Information'),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 16),

                      // Profile Image
                      GestureDetector(
                        onTap: () {
                          controller.showImageSourceDialog(context);
                        },
                        child: Obx(() {
                          if (controller.profileImage.value != null) {
                            return ClipOval(
                              child: Image.file(
                                File(controller.profileImage.value!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else if (Prefs.getAvatar.isNotEmpty) {
                            return ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: Prefs.getAvatar,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => ProgressBar(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      AppIcons.addImage,
                                      width: 100,
                                      height: 100,
                                    ),
                              ),
                            );
                          } else {
                            return Image.asset(
                              AppIcons.addImage,
                              width: 100,
                              height: 100,
                            );
                          }
                        }),
                      ),
                      SizedBox(height: 8),
                      PrimaryText(
                        text: "Edit Profile Image",
                        textColor: context.resources.color.colorGrey5,
                      ),

                      SizedBox(height: 16),

                      // First Name
                      LabeledTextFiled(
                        label: "First Name",
                        hint: "First Name",
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: true,
                        controller: controller.firstNameController,
                      ),

                      // Last Name
                      LabeledTextFiled(
                        label: "Last Name",
                        hint: "Last Name",
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: true,
                        controller: controller.lastNameController,
                      ),

                      // Title
                      LabeledTextFiled(
                        label: "Title",
                        hint: "Title",
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: true,
                        controller: controller.titleController,
                      ),

                      // Email
                      LabeledTextFiled(
                        label: "Email Address",
                        hint: "Email Address",
                        inputType: TextInputType.emailAddress,
                        isPassword: false,
                        isMandatory: true,
                        controller: controller.emailController,
                      ),

                      // Gender
                      Obx(
                        () => PrimaryChooser(
                          label: "Gender",
                          text: "Gender",
                          selected: controller.selectedGender.value.isNotEmpty
                              ? controller.selectedGender.value
                              : null,
                          onSelect: (value) {
                            controller.selectedGender.value = value;
                          },
                          withArrow: true,
                          isMandatory: true,
                          list: controller.genders,
                          isMultiSelect: false,
                        ),
                      ),

                      // Date of Birth
                      Obx(
                        () => DateChooser(
                          text: controller.selectedDate.value == null
                              ? 'dd/MM/yyyy'
                              : DateFormat(
                                  'dd/MM/yyyy',
                                ).format(controller.selectedDate.value!),
                          isMandatory: false,
                          onSelectDate: (d) {
                            controller.selectedDate.value = d;
                          },
                          label: "Date of Birth",
                        ),
                      ),

                      // Portfolio Link
                      LabeledTextFiled(
                        label: "Portfolio Link",
                        hint: "Portfolio Link",
                        inputType: TextInputType.url,
                        isPassword: false,
                        isMandatory: false,
                        controller: controller.portfolioLinkController,
                      ),

                      // About
                      MultilineLabeledTextField(
                        label: "About",
                        hint: "Tell us about yourself...",
                        inputType: TextInputType.multiline,
                        isPassword: false,
                        isMandatory: false,
                        controller: controller.aboutController,
                        height: 120,
                        margin: 0,
                      ),

                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Update Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => controller.isLoading.value
                    ? ProgressBar()
                    : PrimaryButton(
                        title: "Update Profile",
                        onPressed: () {
                          controller.updateProfile();
                        },
                      ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
