import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../../../components/labeled_text_field.dart';
import 'add_address_controller.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAddressController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopHeader(
                hasBack: true,
                title: controller.isEditMode.value
                    ? Resources.of(context).strings.editAddress
                    : Resources.of(context).strings.addAddress,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledTextFiled(
                      controller: controller.labelController,
                      hint: Resources.of(context).strings.label,
                      label: Resources.of(context).strings.label,
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.addressController,
                      hint: Resources.of(context).strings.address,
                      label: Resources.of(context).strings.address,
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.cityController,
                      hint: Resources.of(context).strings.city,
                      label: Resources.of(context).strings.city,
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.streetController,
                      hint: Resources.of(context).strings.street,
                      label: Resources.of(context).strings.street,
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.buildingController,
                      hint: Resources.of(context).strings.building,
                      label: Resources.of(context).strings.building,
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.apartmentController,
                      hint: Resources.of(context).strings.apartment,
                      label: Resources.of(context).strings.apartment,
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Obx(
              () => controller.isLoading.value
                  ? ProgressBar()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: PrimaryButton(
                        title: controller.isEditMode.value
                            ? Resources.of(context).strings.saveAddress
                            : Resources.of(context).strings.addAddress,
                        onPressed: () {
                          controller.saveAddress();
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
