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
import 'package:wazafak_app/utils/res/Resources.dart';

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
            TopHeader(hasBack: true, title: Resources
                .of(context)
                .strings
                .personalInformation),
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
                        text: Resources
                            .of(context)
                            .strings
                            .editProfileImage,
                        textColor: context.resources.color.colorGrey5,
                      ),

                      SizedBox(height: 16),

                      // First Name
                      LabeledTextFiled(
                        label: Resources
                            .of(context)
                            .strings
                            .firstName,
                        hint: Resources
                            .of(context)
                            .strings
                            .firstName,
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: true,
                        controller: controller.firstNameController,
                      ),

                      // Last Name
                      LabeledTextFiled(
                        label: Resources
                            .of(context)
                            .strings
                            .lastName,
                        hint: Resources
                            .of(context)
                            .strings
                            .lastName,
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: true,
                        controller: controller.lastNameController,
                      ),

                      // Title
                      LabeledTextFiled(
                        label: Resources
                            .of(context)
                            .strings
                            .title,
                        hint: Resources
                            .of(context)
                            .strings
                            .title,
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: true,
                        controller: controller.titleController,
                      ),

                      // Email
                      LabeledTextFiled(
                        label: Resources
                            .of(context)
                            .strings
                            .emailAddress,
                        hint: Resources
                            .of(context)
                            .strings
                            .emailAddress,
                        inputType: TextInputType.emailAddress,
                        isPassword: false,
                        isMandatory: true,
                        controller: controller.emailController,
                      ),

                      // Gender
                      Obx(
                        () => PrimaryChooser(
                          label: Resources
                              .of(context)
                              .strings
                              .gender,
                          text: Resources
                              .of(context)
                              .strings
                              .gender,
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
                          label: Resources
                              .of(context)
                              .strings
                              .dateOfBirth,
                          minDate: DateTime(1900),
                          maxDate: DateTime.now().subtract(Duration(days: 18 * 365 + 4)),
                        ),
                      ),

                      // Portfolio Link
                      LabeledTextFiled(
                        label: Resources
                            .of(context)
                            .strings
                            .portfolioLink,
                        hint: Resources
                            .of(context)
                            .strings
                            .portfolioLink,
                        inputType: TextInputType.url,
                        isPassword: false,
                        isMandatory: false,
                        controller: controller.portfolioLinkController,
                      ),

                      // About
                      MultilineLabeledTextField(
                        label: Resources
                            .of(context)
                            .strings
                            .about,
                        hint: Resources
                            .of(context)
                            .strings
                            .tellUsAboutYourself,
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
                  title: Resources
                      .of(context)
                      .strings
                      .updateProfile,
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
