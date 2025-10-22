import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

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
                      dataController.showImageSourceDialog();
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
                    text: "Add Profile Image",
                    textColor: context.resources.color.colorGrey5,
                  ),

                  SizedBox(height: 16),

                  LabeledTextFiled(
                    label: "First Name",
                    hint: "First Name",
                    inputType: TextInputType.text,
                    isPassword: false,
                    isMandatory: true,
                    controller: dataController.firstNameController,
                  ),
                  LabeledTextFiled(
                    label: "Last Name",
                    hint: "Last Name",
                    inputType: TextInputType.text,
                    isPassword: false,
                    isMandatory: true,
                    controller: dataController.lastNameController,
                  ),
                  LabeledTextFiled(
                    label: "Title",
                    hint: "Title",
                    inputType: TextInputType.text,
                    isPassword: false,
                    isMandatory: true,
                    controller: dataController.titleController,
                  ),
                  LabeledTextFiled(
                    label: "Email Address",
                    hint: "Email Address",
                    inputType: TextInputType.emailAddress,
                    isPassword: false,
                    isMandatory: true,
                    controller: dataController.emailController,
                  ),

                  Obx(
                    () => PrimaryChooser(
                      label: "Gender",
                      text: "Gender",
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
                      label: "Date of Birth",
                    ),
                  ),
                  LabeledTextFiled(
                    label: "Password",
                    hint: "New Password",
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                    isMandatory: true,
                    controller: dataController.passwordController,
                  ),
                  LabeledTextFiled(
                    label: "Confirm Password",
                    hint: "Confirm Password",
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
            title: "Next",
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
