import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/category_chooser.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

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
                    SizedBox(height: 8),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: PrimaryButton(
                title: 'Save Service',
                onPressed: () {
                  if (controller.validateFields()) {
                    // Handle save service
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
