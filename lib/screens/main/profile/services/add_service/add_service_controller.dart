import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazafak_app/components/sheets/image_source_bottom_sheet.dart';
import 'package:wazafak_app/components/sheets/success_sheet.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/model/WorkingHoursModel.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/service/add_service_repository.dart';
import 'package:wazafak_app/repository/service/save_service_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

class AddServiceController extends GetxController {
  final _repository = AddServiceRepository();
  final _saveServiceRepository = SaveServiceRepository();
  final _categoriesRepository = CategoriesRepository();

  final descController = TextEditingController();
  final titleController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final workExperienceController = TextEditingController();

  var selectedCategory = Rxn<Category>();
  var selectedSubcategory = Rxn<Category>();
  var subcategories = <Category>[].obs;
  var isLoadingSubcategories = false.obs;
  var selectedDuration = '15 minutes'.obs;
  var selectedBufferTime = '15 minutes'.obs;
  var selectedSkills = <Skill>[].obs;
  var selectedAddresses = <Address>[].obs;
  var isLoading = false.obs;

  var workingHours = <WorkingHoursDay>[].obs;

  final ImagePicker _imagePicker = ImagePicker();
  var portfolioImage = Rxn<File>();
  var portfolioImageBase64 = Rxn<String>();
  var portfolioImageUrl =
      Rxn<String>(); // For displaying existing image from server

  var isEditMode = false.obs;
  String? editServiceHashcode;

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
    _initializeWorkingHours();

    // Check if we're in edit mode
    final Service? service = Get.arguments as Service?;
    if (service != null) {
      isEditMode.value = true;
      editServiceHashcode = service.hashcode;
      _populateFieldsFromService(service);
    }
  }

  Future<void> _populateFieldsFromService(Service service) async {
    // Reset category selections
    selectedCategory.value = null;
    selectedSubcategory.value = null;
    subcategories.clear();

    // Populate text fields
    titleController.text = service.title ?? '';
    descController.text = service.description ?? '';
    hourlyRateController.text = service.unitPrice ?? '';
    workExperienceController.text = service.experience ?? '';

    // Set duration and buffer time - ensure they match with list items
    if (service.availableDuration != null) {
      final durationString = '${service.availableDuration} minutes';
      // Only set if it exists in the options list
      if (durationOptions.contains(durationString)) {
        selectedDuration.value = durationString;
      }
    }
    if (service.availableBuffer != null) {
      final bufferString = '${service.availableBuffer} minutes';
      // Only set if it exists in the options list
      if (bufferTimeOptions.contains(bufferString)) {
        selectedBufferTime.value = bufferString;
      }
    }

    // Set selected skills
    if (service.skills != null) {
      selectedSkills.value = service.skills!;
    }

    // Set portfolio image URL if exists
    if (service.portfolio != null && service.portfolio!.isNotEmpty) {
      portfolioImageUrl.value = service.portfolio;
    }

    // Set selected addresses (convert Area to Address)
    if (service.areas != null) {
      selectedAddresses.value = service.areas!
          .map(
            (area) => Address(
              hashcode: area.hashcode,
              label: area.label,
              city: area.city,
              address: area.address,
              street: area.street,
              building: area.building,
              apartment: area.apartment,
              latitude: area.latitude,
              longitude: area.longitude,
            ),
          )
          .toList();
    }

    // Set working hours from availability
    if (service.availability != null && service.availability!.isNotEmpty) {
      // First, disable all days
      for (var day in workingHours) {
        day.isEnabled = false;
      }

      // Then enable and set times for days in availability
      for (var availability in service.availability!) {
        final dayName = _getDayNameFromAbbreviation(availability.day ?? '');
        final dayIndex = workingHours.indexWhere((d) => d.day == dayName);
        if (dayIndex != -1) {
          workingHours[dayIndex].isEnabled = true;
          workingHours[dayIndex].startTime = availability.startTime ?? '09:00';
          workingHours[dayIndex].endTime = availability.endTime ?? '17:00';
        }
      }
      workingHours.refresh();
    }

    // Set category - find from HomeController's categories list
    if (service.parentCategoryHashcode == null) {
      final category = Prefs.getCategories.firstWhereOrNull(
        (cat) => cat.hashcode == service.categoryHashcode,
      );

      if (category != null) {
        selectedCategory.value = category;
      }
    } else {
      final category = Prefs.getCategories.firstWhereOrNull(
        (cat) => cat.hashcode == service.parentCategoryHashcode,
      );

      if (category != null) {
        selectedCategory.value = category;
      }

      await getSubcategories(service.parentCategoryHashcode.toString());

      selectedSubcategory.value = subcategories.firstWhereOrNull(
        (cat) => cat.hashcode == service.categoryHashcode,
      );
    }
  }

  String _getDayNameFromAbbreviation(String abbr) {
    switch (abbr.toUpperCase()) {
      case 'MON':
        return 'Monday';
      case 'TUE':
        return 'Tuesday';
      case 'WED':
        return 'Wednesday';
      case 'THU':
        return 'Thursday';
      case 'FRI':
        return 'Friday';
      case 'SAT':
        return 'Saturday';
      case 'SUN':
        return 'Sunday';
      default:
        return '';
    }
  }

  void _initializeWorkingHours() {
    workingHours.value = [
      WorkingHoursDay(day: 'Monday'),
      WorkingHoursDay(day: 'Tuesday'),
      WorkingHoursDay(day: 'Wednesday'),
      WorkingHoursDay(day: 'Thursday'),
      WorkingHoursDay(day: 'Friday'),
      WorkingHoursDay(day: 'Saturday', isEnabled: false),
      WorkingHoursDay(day: 'Sunday', isEnabled: false),
    ];
  }

  void toggleDayEnabled(int index, bool value) {
    workingHours[index].isEnabled = value;
    workingHours.refresh();
  }

  void updateStartTime(int index, String time) {
    workingHours[index].startTime = time;
    workingHours.refresh();
  }

  void updateEndTime(int index, String time) {
    workingHours[index].endTime = time;
    workingHours.refresh();
  }

  void selectCategory(Category? category) {
    selectedCategory.value = category;
    selectedSubcategory.value = null; // Reset subcategory when category changes
    subcategories.clear();

    // Fetch subcategories if category is selected
    if (category?.hashcode != null) {
      if (category?.hasSubCategories ?? false) {
        getSubcategories(category!.hashcode!);
      }
    }
  }

  void selectSubcategory(Category? subcategory) {
    selectedSubcategory.value = subcategory;
  }

  Future<void> getSubcategories(String parentHashcode) async {
    try {
      isLoadingSubcategories.value = true;

      final response = await _categoriesRepository.getCategories(
        parent: parentHashcode,
      );

      if (response.success == true && response.data?.list != null) {
        subcategories.value = response.data!.list!;
      } else {
        subcategories.clear();
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
      subcategories.clear();
    } finally {
      isLoadingSubcategories.value = false;
    }
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

  Future<void> pickPortfolioImage(BuildContext context) async {
    try {
      final XFile? image = await ImageSourceBottomSheet.show(context);

      if (image != null) {
        portfolioImage.value = File(image.path);

        // Convert to base64
        final bytes = await portfolioImage.value!.readAsBytes();
        portfolioImageBase64.value =
            "data:image/jpeg;base64,${base64Encode(bytes)}";

        constants.showSnackBar(
          'Portfolio image selected successfully',
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error selecting image: $e', SnackBarStatus.ERROR);
      print('Error picking portfolio image: $e');
    }
  }

  void removePortfolioImage() {
    portfolioImage.value = null;
    portfolioImageBase64.value = null;
    portfolioImageUrl.value = null;
  }

  bool validateFields() {
    if (titleController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter title', SnackBarStatus.ERROR);
      return false;
    }
    if (descController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter Description', SnackBarStatus.ERROR);
      return false;
    }
    if (selectedAddresses.isEmpty) {
      constants.showSnackBar(
        'Please select at least one address',
        SnackBarStatus.ERROR,
      );
      return false;
    }
    if (selectedCategory.value == null) {
      constants.showSnackBar('Please select category', SnackBarStatus.ERROR);
      return false;
    }
    if (hourlyRateController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter hourly rate', SnackBarStatus.ERROR);
      return false;
    }
    if (workExperienceController.text.trim().isEmpty) {
      constants.showSnackBar(
        'Please enter work experience',
        SnackBarStatus.ERROR,
      );
      return false;
    }
    if (selectedSkills.isEmpty) {
      constants.showSnackBar(
        'Please select at least one skill',
        SnackBarStatus.ERROR,
      );
      return false;
    }

    return true;
  }

  Future<void> addService() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      // Extract minutes from duration string (e.g., "15 minutes" -> 15)
      final durationMinutes = int.parse(
        selectedDuration.value.split(' ').first,
      );
      final bufferMinutes = int.parse(
        selectedBufferTime.value.split(' ').first,
      );

      // Use subcategory if selected, otherwise use main category
      final categoryHashcode =
          selectedSubcategory.value?.hashcode ??
          selectedCategory.value!.hashcode;

      // Prepare working hours data - format as nested object with day keys
      final workingHoursData = <String, Map<String, String>>{};
      for (var day in workingHours.where((day) => day.isEnabled)) {
        final dayKey = day.day.toUpperCase().substring(0, 3);
        workingHoursData[dayKey] = {
          'start_time': day.startTime,
          'end_time': day.endTime,
        };
      }

      final data = {
        'title': titleController.text,
        'description': descController.text,
        'category': categoryHashcode,
        'unit_price': hourlyRateController.text.trim(),
        'experience': workExperienceController.text,
        'available_duration': durationMinutes,
        'available_buffer': bufferMinutes,
        'skills': selectedSkills.map((s) => s.hashcode).toList(),
        'areas': selectedAddresses.map((a) => a.hashcode).toList(),
        'availability': workingHoursData,
      };

      // // Add portfolio image if selected
      // if (portfolioImageBase64.value != null) {
      //   data['image'] = portfolioImageBase64.value;
      // }

      final response = isEditMode.value
          ? await _saveServiceRepository.saveService(editServiceHashcode!, data)
          : await _repository.addService(data);

      if (response.success == true) {
        SuccessSheet.show(
            Get.context!,
            title: isEditMode.value ? 'Service Updated' : 'Service Posted',
            image: AppIcons.servicePosted,
            description:
            'Your service is now live! Keep an eye out for opportunities.',
            buttonText: 'View Profile',
            onButtonPressed: () {
              Navigator.pop(Get.context!);
            }
        );
      } else {
        constants.showSnackBar(
          response.message ??
              (isEditMode.value
                  ? 'Failed to update service'
                  : 'Failed to add service'),
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error adding service: $e', SnackBarStatus.ERROR);
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
