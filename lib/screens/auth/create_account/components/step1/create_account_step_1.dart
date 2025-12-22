import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../../../components/date_chooser.dart';
import '../../../../../components/primary_button.dart';
import '../../../../../components/primary_chooser.dart';
import '../../create_account_controller.dart';

class CreateAccountStep1 extends StatelessWidget {
  CreateAccountStep1({super.key});

  final CreateAccountController dataController = Get.put(
    CreateAccountController(),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 8),

                  GestureDetector(
                    onTap: () {
                      dataController.showImageSourceDialog(context);
                    },
                    child: Obx(
                          () =>
                      dataController.profileImage.value != null
                          ? ClipOval(
                        child: Image.file(
                          File(dataController.profileImage.value!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Image.asset(
                          AppIcons.addImage, width: 100, height: 100),
                    ),
                  ),
                  SizedBox(height: 8),
                  PrimaryText(
                    text: Resources
                        .of(context)
                        .strings
                        .addProfileImage,
                    textColor: context.resources.color.colorGrey5,
                  ),

                  SizedBox(height: 16),

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
                    controller: dataController.firstNameController,
                  ),
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
                    controller: dataController.lastNameController,
                  ),
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
                    controller: dataController.titleController,
                  ),
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
                    controller: dataController.emailController,
                  ),

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
                      selected: dataController.selectedGender.value,
                      onSelect: (value) {
                        dataController.selectedGender.value = value;
                      },
                      withArrow: true,
                      isMandatory: true,
                      list: dataController.genders,
                      isMultiSelect: false,
                    ),
                  ),

                  Obx(
                    () => DateChooser(
                      text: dataController.selectedDate.value == null
                          ? 'dd/MM/yyyy'
                          : DateFormat(
                              'dd/MM/yyyy',
                            ).format(dataController.selectedDate.value!),
                      isMandatory: false,
                      onSelectDate: (d) {
                        dataController.selectedDate.value = d;
                      },
                      label: Resources
                          .of(context)
                          .strings
                          .dateOfBirth,
                    ),
                  ),
                  LabeledTextFiled(
                    label: Resources
                        .of(context)
                        .strings
                        .password,
                    hint: Resources
                        .of(context)
                        .strings
                        .newPassword,
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                    isMandatory: true,
                    controller: dataController.passwordController,
                  ),
                  LabeledTextFiled(
                    label: Resources
                        .of(context)
                        .strings
                        .confirmPassword,
                    hint: Resources
                        .of(context)
                        .strings
                        .confirmPassword,
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                    isMandatory: true,
                    controller: dataController.confirmPasswordController,
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          PrimaryButton(
            title: Resources
                .of(context)
                .strings
                .next,
            onPressed: () {
              dataController.verifyStep1();
            },
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
