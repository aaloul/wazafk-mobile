import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

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
                    ? 'Edit Address'
                    : 'Add Address',
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
                      hint: 'Label',
                      label: 'Label',
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.addressController,
                      hint: 'Address',
                      label: 'Address',
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.streetController,
                      hint: 'Street',
                      label: 'Street',
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.buildingController,
                      hint: 'Building',
                      label: 'Building',
                      isMandatory: true,
                      isPassword: false,
                      inputType: TextInputType.text,
                    ),
                    LabeledTextFiled(
                      controller: controller.apartmentController,
                      hint: 'Apartment',
                      label: 'Apartment',
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
                            ? "Save Address"
                            : "Add Address",
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
