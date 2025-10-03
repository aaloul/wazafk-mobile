import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';

class AddServiceController extends GetxController {
  final titleController = TextEditingController();
  var selectedCategory = Rxn<Category>();

  @override
  void onInit() {
    super.onInit();
  }

  void selectCategory(Category? category) {
    selectedCategory.value = category;
  }

  bool validateFields() {
    if (titleController.text.trim().isEmpty) {
      return false;
    }
    if (selectedCategory.value == null) {
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }
}
