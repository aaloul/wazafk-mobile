import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazafak_app/components/sheets/image_source_bottom_sheet.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/model/WorkingHoursModel.dart';
import 'package:wazafak_app/repository/package/add_package_repository.dart';
import 'package:wazafak_app/repository/package/save_package_repository.dart';
import 'package:wazafak_app/repository/service/services_list_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../../components/sheets/success_sheet.dart';
import '../../../../../utils/Prefs.dart';
import '../../../../../utils/res/AppIcons.dart';

class AddPackageController extends GetxController {
  final _repository = AddPackageRepository();
  final _savePackageRepository = SavePackageRepository();
  final _servicesRepository = ServicesListRepository();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  // final unitPriceController = TextEditingController();
  final totalPriceController = TextEditingController();

  var isLoading = false.obs;

  final ImagePicker _imagePicker = ImagePicker();
  var packageImage = Rxn<File>();
  var packageImageBase64 = Rxn<String>();
  var packageImageUrl =
      Rxn<String>(); // For displaying existing image from server

  var isEditMode = false.obs;
  String? editPackageHashcode;

  var workingHours = <WorkingHoursDay>[].obs;
  var services = <Service>[].obs;
  var selectedServices = <Service>[].obs;
  var isLoadingServices = false.obs;


  @override
  void onInit() {
    super.onInit();
    _initializeWorkingHours();
    fetchServices();

    // Check if we're in edit mode
    final arguments = Get.arguments;
    if (arguments != null) {
      if (arguments is Package) {
        // If it's a Package object directly
        isEditMode.value = true;
        editPackageHashcode = arguments.hashcode;
        _populateFieldsFromPackageObject(arguments);
      } else if (arguments is Map) {
        // If it's a Map (legacy support)
        isEditMode.value = true;
        editPackageHashcode = arguments['hashcode'];
        _populateFieldsFromPackage(arguments);
      }
    }
  }

  Future<void> fetchServices() async {
    try {
      isLoadingServices.value = true;

      Map<String, String>? filters = {};
      filters['member'] = Prefs.getId;

      final response = await _servicesRepository.getServices(filters: filters);

      if (response.success == true && response.data?.list != null) {
        services.value = response.data!.list!;
      }
    } catch (e) {
      print('Error fetching services: $e');
    } finally {
      isLoadingServices.value = false;
    }
  }

  void toggleServiceSelection(Service service) {
    if (isServiceSelected(service)) {
      selectedServices.removeWhere((s) => s.hashcode == service.hashcode);
    } else {
      selectedServices.add(service);
    }
  }

  bool isServiceSelected(Service service) {
    return selectedServices.any((s) => s.hashcode == service.hashcode);
  }

  void _initializeWorkingHours() {
    workingHours.value = [
      WorkingHoursDay(day: Resources
          .of(Get.context!)
          .strings
          .monday),
      WorkingHoursDay(day: Resources
          .of(Get.context!)
          .strings
          .tuesday),
      WorkingHoursDay(day: Resources
          .of(Get.context!)
          .strings
          .wednesday),
      WorkingHoursDay(day: Resources
          .of(Get.context!)
          .strings
          .thursday),
      WorkingHoursDay(day: Resources
          .of(Get.context!)
          .strings
          .friday),
      WorkingHoursDay(day: Resources
          .of(Get.context!)
          .strings
          .saturday, isEnabled: false),
      WorkingHoursDay(day: Resources
          .of(Get.context!)
          .strings
          .sunday, isEnabled: false),
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

  void _populateFieldsFromPackageObject(Package package) {
    // Populate text fields
    titleController.text = package.title ?? '';
    descController.text = package.description ?? '';
    // unitPriceController.text = package.unitPrice ?? '';
    totalPriceController.text = package.totalPrice ?? '';



    // Set package image URL if exists
    if (package.image != null && package.image!.isNotEmpty) {
      packageImageUrl.value = package.image;
    }

    // Set working hours from availability
    if (package.availability != null && package.availability!.isNotEmpty) {
      // First, disable all days
      for (var day in workingHours) {
        day.isEnabled = false;
      }

      // Then enable and set times for days in availability
      for (var availability in package.availability!) {
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

    // Set selected services
    if (package.services != null && package.services!.isNotEmpty) {
      selectedServices.clear();
      for (var service in package.services!) {
        selectedServices.add(service);
      }
    }
  }

  void _populateFieldsFromPackage(Map package) {
    // Populate text fields
    titleController.text = package['title'] ?? '';
    descController.text = package['description'] ?? '';
    // unitPriceController.text = package['unit_price'] ?? '';
    totalPriceController.text = package['total_price'] ?? '';


    // Set package image URL if exists
    if (package['image'] != null && package['image'].toString().isNotEmpty) {
      packageImageUrl.value = package['image'];
    }

    // Set working hours from availability
    if (package['availability'] != null && package['availability'] is List) {
      // First, disable all days
      for (var day in workingHours) {
        day.isEnabled = false;
      }

      // Then enable and set times for days in availability
      for (var availability in package['availability']) {
        final dayName = _getDayNameFromAbbreviation(availability['day'] ?? '');
        final dayIndex = workingHours.indexWhere((d) => d.day == dayName);
        if (dayIndex != -1) {
          workingHours[dayIndex].isEnabled = true;
          workingHours[dayIndex].startTime =
              availability['start_time'] ?? '09:00';
          workingHours[dayIndex].endTime = availability['end_time'] ?? '17:00';
        }
      }
      workingHours.refresh();
    }

    // Set selected services
    if (package['services'] != null && package['services'] is List) {
      selectedServices.clear();
      for (var serviceData in package['services']) {
        if (serviceData is Map) {
          final service = Service.fromJson(
            Map<String, dynamic>.from(serviceData),
          );
          selectedServices.add(service);
        }
      }
    }
  }

  String _getDayNameFromAbbreviation(String abbr) {
    switch (abbr.toUpperCase()) {
      case 'MON':
        return Resources
            .of(Get.context!)
            .strings
            .monday;
      case 'TUE':
        return Resources
            .of(Get.context!)
            .strings
            .tuesday;
      case 'WED':
        return Resources
            .of(Get.context!)
            .strings
            .wednesday;
      case 'THU':
        return Resources
            .of(Get.context!)
            .strings
            .thursday;
      case 'FRI':
        return Resources
            .of(Get.context!)
            .strings
            .friday;
      case 'SAT':
        return Resources
            .of(Get.context!)
            .strings
            .saturday;
      case 'SUN':
        return Resources
            .of(Get.context!)
            .strings
            .sunday;
      default:
        return '';
    }
  }



  Future<void> pickPackageImage(BuildContext context) async {
    try {
      final XFile? image = await ImageSourceBottomSheet.show(context);

      if (image != null) {
        packageImage.value = File(image.path);

        // Convert to base64
        final bytes = await packageImage.value!.readAsBytes();
        packageImageBase64.value =
            "data:image/jpeg;base64,${base64Encode(bytes)}";

        constants.showSnackBar(
          Resources
              .of(Get.context!)
              .strings
              .packageImageSelectedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorSelectingImage(e.toString()), SnackBarStatus.ERROR);
      print('Error picking package image: $e');
    }
  }

  void removePackageImage() {
    packageImage.value = null;
    packageImageBase64.value = null;
    packageImageUrl.value = null;
  }

  bool validateFields() {
    if (titleController.text.trim().isEmpty) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseEnterTitle, SnackBarStatus.ERROR);
      return false;
    }
    if (descController.text.trim().isEmpty) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseEnterDescription, SnackBarStatus.ERROR);
      return false;
    }
    // if (unitPriceController.text.trim().isEmpty) {
    //   constants.showSnackBar(Resources
    //       .of(Get.context!)
    //       .strings
    //       .pleaseEnterUnitPrice, SnackBarStatus.ERROR);
    //   return false;
    // }
    if (totalPriceController.text.trim().isEmpty) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseEnterTotalPrice, SnackBarStatus.ERROR);
      return false;
    }

    return true;
  }

  Future<void> addPackage() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

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
        'title': titleController.text.trim(),
        'description': descController.text.trim(),
        // 'unit_price': unitPriceController.text.trim(),
        'total_price': totalPriceController.text.trim(),
        // 'available_duration': durationMinutes,
        // 'available_buffer': bufferMinutes,
        'availability': workingHoursData,
        'services': selectedServices.map((s) => s.hashcode).toList(),
      };

      // Add package image if selected
      if (packageImageBase64.value != null) {
        data['image'] = packageImageBase64.value.toString();
      }

      final response = isEditMode.value
          ? await _savePackageRepository.savePackage(editPackageHashcode!, data)
          : await _repository.addPackage(data);

      if (response.success == true) {
        SuccessSheet.show(
            Get.context!,
            title: isEditMode.value ? Resources
                .of(Get.context!)
                .strings
                .packageUpdated : Resources
                .of(Get.context!)
                .strings
                .packagePosted,
            image: AppIcons.servicePosted,
            description:
            Resources
                .of(Get.context!)
                .strings
                .yourPackageIsNowLive,
            buttonText: Resources
                .of(Get.context!)
                .strings
                .viewProfile,
            onButtonPressed: () {
              Navigator.pop(Get.context!);
            }
        );
      } else {
        constants.showSnackBar(
          response.message ??
              (isEditMode.value
                  ? Resources
                  .of(Get.context!)
                  .strings
                  .failedToUpdatePackage
                  : Resources
                  .of(Get.context!)
                  .strings
                  .failedToAddPackage),
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorAddingPackageWithParam(e.toString()), SnackBarStatus.ERROR);
      print('Error adding package: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    // unitPriceController.dispose();
    totalPriceController.dispose();
    super.onClose();
  }
}
