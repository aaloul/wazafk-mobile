import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/repository/service/add_service_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class AddServiceController extends GetxController {
  final _repository = AddServiceRepository();

  final titleController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final workExperienceController = TextEditingController();

  var selectedCategory = Rxn<Category>();
  var selectedDuration = '15 minutes'.obs;
  var selectedBufferTime = '15 minutes'.obs;
  var selectedSkills = <Skill>[].obs;
  var selectedAddresses = <Address>[].obs;
  var isLoading = false.obs;

  final List<String> durationOptions = [
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '60 minutes',
    '90 minutes',
    '120 minutes',
    '180 minutes',
  ];

  final List<String> bufferTimeOptions = [
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '60 minutes',
    '90 minutes',
    '120 minutes',
    '180 minutes',
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void selectCategory(Category? category) {
    selectedCategory.value = category;
  }

  void selectDuration(String? duration) {
    if (duration != null) {
      selectedDuration.value = duration;
    }
  }

  void selectBufferTime(String? bufferTime) {
    if (bufferTime != null) {
      selectedBufferTime.value = bufferTime;
    }
  }

  void toggleSkillSelection(Skill skill) {
    if (isSkillSelected(skill)) {
      selectedSkills.removeWhere((s) => s.hashcode == skill.hashcode);
    } else {
      selectedSkills.add(skill);
    }
  }

  bool isSkillSelected(Skill skill) {
    return selectedSkills.any((s) => s.hashcode == skill.hashcode);
  }

  void toggleAddressSelection(Address address) {
    if (isAddressSelected(address)) {
      selectedAddresses.removeWhere((a) => a.hashcode == address.hashcode);
    } else {
      selectedAddresses.add(address);
    }
  }

  bool isAddressSelected(Address address) {
    return selectedAddresses.any((a) => a.hashcode == address.hashcode);
  }

  bool validateFields() {
    if (titleController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter title', SnackBarStatus.ERROR);
      return false;
    }
    if (selectedAddresses.isEmpty) {
      constants.showSnackBar(
          'Please select at least one address', SnackBarStatus.ERROR);
      return false;
    }
    if (selectedCategory.value == null) {
      constants.showSnackBar('Please select category', SnackBarStatus.ERROR);
      return false;
    }
    if (hourlyRateController.text
        .trim()
        .isEmpty) {
      constants.showSnackBar('Please enter hourly rate', SnackBarStatus.ERROR);
      return false;
    }
    if (workExperienceController.text
        .trim()
        .isEmpty) {
      constants.showSnackBar(
          'Please enter work experience', SnackBarStatus.ERROR);
      return false;
    }
    if (selectedSkills.isEmpty) {
      constants.showSnackBar(
          'Please select at least one skill', SnackBarStatus.ERROR);
      return false;
    }

    return true;
  }

  Future<void> addService() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      // Extract minutes from duration string (e.g., "15 minutes" -> 15)
      final durationMinutes = int.parse(selectedDuration.value
          .split(' ')
          .first);
      final bufferMinutes = int.parse(selectedBufferTime.value
          .split(' ')
          .first);

      final data = {
        'title': titleController.text,
        'category': selectedCategory.value!.hashcode,
        'unit_price': hourlyRateController.text.trim(),
        'experience': workExperienceController.text,
        'available_duration': durationMinutes,
        'available_buffer': bufferMinutes,
        'skills': selectedSkills.map((s) => s.hashcode).toList(),
        'areas': selectedAddresses.map((a) => a.hashcode).toList(),
      };

      final response = await _repository.addService(data);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Service added successfully',
          SnackBarStatus.SUCCESS,
        );
        Get.back();
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to add service',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error adding service: $e',
        SnackBarStatus.ERROR,
      );
      print('Error adding service: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    hourlyRateController.dispose();
    workExperienceController.dispose();
    super.onClose();
  }
}

