import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazafak_app/components/sheets/image_source_bottom_sheet.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/LimitsResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/model/WorkingHoursModel.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/app/limits_repository.dart';
import 'package:wazafak_app/repository/package/add_package_repository.dart';
import 'package:wazafak_app/repository/package/package_status_repository.dart';
import 'package:wazafak_app/repository/package/save_package_repository.dart';
import 'package:wazafak_app/repository/service/services_list_repository.dart';
import 'package:wazafak_app/utils/posting_limits.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../../components/sheets/success_sheet.dart';
import '../../../../../utils/Prefs.dart';
import '../../../../../utils/res/AppIcons.dart';

class AddPackageController extends GetxController {
  final _repository = AddPackageRepository();
  final _savePackageRepository = SavePackageRepository();
  final _servicesRepository = ServicesListRepository();
  final _categoriesRepository = CategoriesRepository();
  final _statusRepository = PackageStatusRepository();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  // final unitPriceController = TextEditingController();
  final totalPriceController = TextEditingController();

  var isLoading = false.obs;
  var selectedWorkLocationType = Rxn<String>();

  final ImagePicker _imagePicker = ImagePicker();
  var packageImage = Rxn<File>();
  var packageImageBase64 = Rxn<String>();
  var packageImageUrl =
      Rxn<String>(); // For displaying existing image from server

  var isEditMode = false.obs;
  String? editPackageHashcode;

  /// Category picker (design p113) — sent as `category`, like jobs and
  /// services.
  var selectedCategory = Rxn<Category>();
  var selectedSubcategory = Rxn<Category>();
  var subcategories = <Category>[].obs;
  var isLoadingSubcategories = false.obs;

  /// Off / On switch in the edit header (design p115).
  var isPackageActive = true.obs;
  var isUpdatingStatus = false.obs;

  /// `app/limits` — refreshed when the form opens so the pack's allowance and
  /// price are current for anything that reads them.
  final limits = AppLimitsCache.current.obs;

  EntityLimit get packageLimit => limits.value.package;

  Future<AppLimits>? _limitsRequest;

  /// Re-fetched every time the screen opens so allowances and prices are
  /// current; the in-flight call is reused by the steps that wait on it.
  Future<void> _loadLimits() async {
    _limitsRequest = AppLimitsCache.load(forceRefresh: true);
    limits.value = await _limitsRequest!;
  }

  /// Closes the form once the pack is live.
  void _leaveFlow() {
    Get.until(
      (route) => route.settings.name != RouteConstant.addPackageScreen,
    );
  }

  var workingHours = <WorkingHoursDay>[].obs;
  var services = <Service>[].obs;
  var selectedServices = <Service>[].obs;
  var isLoadingServices = false.obs;


  @override
  void onInit() {
    super.onInit();
    _initializeWorkingHours();
    fetchServices();
    _loadLimits();

    // Check if we're in edit mode
    final arguments = Get.arguments;
    if (arguments != null) {
      if (arguments is Package) {
        // If it's a Package object directly
        isEditMode.value = true;
        editPackageHashcode = arguments.hashcode;
        isPackageActive.value = arguments.status == 1;
        _populateFieldsFromPackageObject(arguments);
      } else if (arguments is Map) {
        // If it's a Map (legacy support)
        isEditMode.value = true;
        editPackageHashcode = arguments['hashcode'];
        _populateFieldsFromPackage(arguments);
      }
    }
  }

  Future<void> loadSubcategories(String parentHashcode) async {
    try {
      isLoadingSubcategories.value = true;
      final response = await _categoriesRepository.getCategories(
        parent: parentHashcode,
        type: 'S',
      );
      if (response.success == true) {
        subcategories.value = response.data?.list ?? [];
      }
    } catch (e) {
      print('Error loading subcategories: $e');
    } finally {
      isLoadingSubcategories.value = false;
    }
  }

  /// Off / On header switch (design p115). Applies immediately and rolls back
  /// if the call fails.
  Future<void> setPackageActive(bool active) async {
    if (editPackageHashcode == null || isUpdatingStatus.value) return;
    if (isPackageActive.value == active) return;

    final previous = isPackageActive.value;
    isPackageActive.value = active;
    isUpdatingStatus.value = true;
    try {
      final response = await _statusRepository.updatePackageStatus(
        editPackageHashcode!,
        active ? 1 : 0,
      );
      if (response.success != true) {
        isPackageActive.value = previous;
        constants.showSnackBar(
          response.message ??
              Resources.of(Get.context!).strings.failedToUpdatePackageStatus,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      isPackageActive.value = previous;
      constants.showSnackBar(
        Resources.of(Get.context!).strings.failedToUpdatePackageStatus,
        SnackBarStatus.ERROR,
      );
    } finally {
      isUpdatingStatus.value = false;
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

  /// A pack covers one service (design p113). Picking it also fixes the
  /// category and subcategory — they come from the service and aren't editable.
  Future<void> selectService(Service service) async {
    selectedServices.value = [service];
    await _applyCategoryFromService(service);
  }

  bool isServiceSelected(Service service) {
    return selectedServices.any((s) => s.hashcode == service.hashcode);
  }

  /// Mirrors the service's category onto the pack. A service with a parent
  /// category is itself a subcategory pick; otherwise it sits on a main
  /// category with no subcategory.
  Future<void> _applyCategoryFromService(Service service) async {
    selectedCategory.value = null;
    selectedSubcategory.value = null;
    subcategories.clear();

    final parentHashcode = service.parentCategoryHashcode?.toString();
    final categoryHashcode = service.categoryHashcode?.toString();

    if (parentHashcode != null && parentHashcode.isNotEmpty) {
      selectedCategory.value = Category(
        hashcode: parentHashcode,
        name: service.parentCategoryName,
      );
      await loadSubcategories(parentHashcode);
      selectedSubcategory.value = subcategories.firstWhereOrNull(
            (c) => c.hashcode == categoryHashcode,
          ) ??
          (categoryHashcode == null
              ? null
              : Category(
                  hashcode: categoryHashcode,
                  name: service.categoryName,
                ));
    } else if (categoryHashcode != null && categoryHashcode.isNotEmpty) {
      selectedCategory.value = Category(
        hashcode: categoryHashcode,
        name: service.categoryName,
      );
    }
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

    // Set work location type
    switch (package.workLocationType) {
      case 'RMT':
        selectedWorkLocationType.value = 'Remote';
        break;
      case 'HYB':
        selectedWorkLocationType.value = 'Hybrid';
        break;
      case 'SIT':
        selectedWorkLocationType.value = 'Onsite';
        break;
    }



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

    // Set the selected service (one per pack) and its category.
    if (package.services != null && package.services!.isNotEmpty) {
      final service = package.services!.first;
      selectedServices.value = [service];
      _applyCategoryFromService(service);
    }
  }

  void _populateFieldsFromPackage(Map package) {
    // Populate text fields
    titleController.text = package['title'] ?? '';
    descController.text = package['description'] ?? '';
    // unitPriceController.text = package['unit_price'] ?? '';
    totalPriceController.text = package['total_price'] ?? '';

    // Set work location type
    switch (package['work_location_type']) {
      case 'RMT':
        selectedWorkLocationType.value = 'Remote';
        break;
      case 'HYB':
        selectedWorkLocationType.value = 'Hybrid';
        break;
      case 'SIT':
        selectedWorkLocationType.value = 'Onsite';
        break;
    }


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
    if (selectedWorkLocationType.value == null) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseSelectJobType, SnackBarStatus.ERROR);
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

      String workLocationTypeCode = '';
      switch (selectedWorkLocationType.value) {
        case 'Remote':
          workLocationTypeCode = 'RMT';
          break;
        case 'Hybrid':
          workLocationTypeCode = 'HYB';
          break;
        case 'Onsite':
          workLocationTypeCode = 'SIT';
          break;
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
        'work_location_type': workLocationTypeCode,
        if (selectedCategory.value != null)
          'category': selectedSubcategory.value?.hashcode ??
              selectedCategory.value!.hashcode,
      };

      // Add package image if selected
      if (packageImageBase64.value != null) {
        data['image'] = packageImageBase64.value.toString();
      }

      final response = isEditMode.value
          ? await _savePackageRepository.savePackage(editPackageHashcode!, data)
          : await _repository.addPackage(data);

      if (response.success == true) {
        // The allowance and the wallet just changed — refresh both.
        AppLimitsCache.load(forceRefresh: true).then(
          (value) => limits.value = value,
        );
        PostingLimits.refreshWallet();
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
                .viewMyPackages,
            onButtonPressed: _leaveFlow
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
