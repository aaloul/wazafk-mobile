import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazafak_app/components/sheets/image_source_bottom_sheet.dart';
import 'package:wazafak_app/components/sheets/success_sheet.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/AreasResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/LimitsResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/model/WorkingHoursModel.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/app/limits_repository.dart';
import 'package:wazafak_app/repository/app/skills_repository.dart';
import 'package:wazafak_app/repository/service/add_service_repository.dart';
import 'package:wazafak_app/repository/service/save_service_repository.dart';
import 'package:wazafak_app/repository/service/service_status_repository.dart';
import 'package:wazafak_app/repository/service/services_list_repository.dart';
import 'package:wazafak_app/screens/main/profile/activation/activate_service_screen.dart';
import 'package:wazafak_app/screens/main/profile/activation/add_skill_screen.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

class AddServiceController extends GetxController {
  final _repository = AddServiceRepository();
  final _saveServiceRepository = SaveServiceRepository();
  final _serviceStatusRepository = ServiceStatusRepository();
  final _servicesListRepository = ServicesListRepository();
  final _categoriesRepository = CategoriesRepository();
  final _skillsRepository = SkillsRepository();

  final descController = TextEditingController();
  final titleController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final totalPriceController = TextEditingController();
  final workExperienceController = TextEditingController();

  var selectedCategory = Rxn<Category>();
  var selectedSubcategory = Rxn<Category>();
  var subcategories = <Category>[].obs;
  var isLoadingSubcategories = false.obs;

  var selectedPricingType = ''.obs;
  var selectedWorkLocationType = Rxn<String>();
  var selectedSkills = <Skill>[].obs;
  var selectedAreas = <AreaModel>[].obs;
  var isLoading = false.obs;
  var availableSkills = <Skill>[].obs;
  var isLoadingSkills = false.obs;

  var workingHours = <WorkingHoursDay>[].obs;

  final ImagePicker _imagePicker = ImagePicker();
  var portfolioImage = Rxn<File>();
  var portfolioImageBase64 = Rxn<String>();
  var portfolioImageUrl =
      Rxn<String>(); // For displaying existing image from server

  var portfolioFile = Rxn<File>();
  var portfolioFileBase64 = Rxn<String>();
  var portfolioFileName = Rxn<String>();
  var portfolioFileSize = Rxn<int>();
  var portfolioFileExtension = Rxn<String>();
  var portfolioFileUrl = Rxn<String>();

  var isEditMode = false.obs;
  String? editServiceHashcode;

  /// Off / On switch in the edit header (design p107) — the service's live
  /// status, updated straight away through `service/serviceStatus`.
  var isServiceActive = true.obs;
  var isUpdatingStatus = false.obs;

  List<String> get durationOptions =>
      [
        Resources
            .of(Get.context!)
            .strings
            .fifteenMinutes,
        Resources
            .of(Get.context!)
            .strings
            .thirtyMinutes,
        Resources
            .of(Get.context!)
            .strings
            .fortyFiveMinutes,
        Resources
            .of(Get.context!)
            .strings
            .sixtyMinutes,
        Resources
            .of(Get.context!)
            .strings
            .ninetyMinutes,
        Resources
            .of(Get.context!)
            .strings
            .oneHundredTwentyMinutes,
        Resources
            .of(Get.context!)
            .strings
            .oneHundredEightyMinutes,
      ];

  List<String> get bufferTimeOptions =>
      [
        Resources
            .of(Get.context!)
            .strings
            .fifteenMinutes,
        Resources
            .of(Get.context!)
            .strings
            .thirtyMinutes,
        Resources
            .of(Get.context!)
            .strings
            .fortyFiveMinutes,
        Resources
            .of(Get.context!)
            .strings
            .sixtyMinutes,
        Resources
            .of(Get.context!)
            .strings
            .ninetyMinutes,
        Resources
            .of(Get.context!)
            .strings
            .oneHundredTwentyMinutes,
        Resources
            .of(Get.context!)
            .strings
            .oneHundredEightyMinutes,
      ];

  List<String> get pricingTypeOptions =>
      [
        Resources
            .of(Get.context!)
            .strings
            .hourlyRateOption,
        Resources
            .of(Get.context!)
            .strings
            .fixedRateOption,
      ];

  @override
  void onInit() {
    super.onInit();

    selectedPricingType.value = Resources
        .of(Get.context!)
        .strings
        .hourlyRateOption;
    _initializeWorkingHours();
    _loadLimits();

    // Check if we're in edit mode
    final Service? service = Get.arguments as Service?;
    if (service != null) {
      isEditMode.value = true;
      editServiceHashcode = service.hashcode;
      isServiceActive.value = service.status == 1;
      _populateFieldsFromService(service);
    } else {
      _checkFirstService();
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
    totalPriceController.text = service.totalPrice ?? '';
    workExperienceController.text = service.experience ?? '';


    // Set work location type
    switch (service.workLocationType) {
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

    // Set selected skills
    if (service.skills != null) {
      selectedSkills.value = service.skills!;
    }

    // Set portfolio image URL if exists
    if (service.portfolio != null && service.portfolio!.isNotEmpty) {
      portfolioImageUrl.value = service.portfolio;
    }

    // Set portfolio file URL if exists
    if (service.portfolioFile != null && service.portfolioFile!.isNotEmpty) {
      portfolioFileUrl.value = service.portfolioFile;
      portfolioFileName.value = service.portfolioFile!.split('/').last;
    }

    // Set selected areas
    if (service.areas != null) {
      selectedAreas.value = service.areas!
          .map(
            (area) => AreaModel(
              code: area.code,
              name: area.name,
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
        // Fetch skills for the selected category
        await getSkills();
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

      // Fetch skills for the selected subcategory
      await getSkills();
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

  void selectCategory(Category? category) {
    selectedCategory.value = category;
    selectedSubcategory.value = null; // Reset subcategory when category changes
    subcategories.clear();
    selectedSkills.clear(); // Clear selected skills when category changes

    // Fetch subcategories if category is selected
    if (category?.hashcode != null) {
      if (category?.hasSubCategories ?? false) {
        getSubcategories(category!.hashcode!);
      } else {
        // No subcategories, fetch skills directly based on main category
        getSkills();
      }
    } else {
      // No category selected, clear available skills
      availableSkills.clear();
    }
  }

  void selectSubcategory(Category? subcategory) {
    selectedSubcategory.value = subcategory;
    selectedSkills.clear(); // Clear selected skills when subcategory changes

    // Fetch skills based on selected subcategory
    if (subcategory?.hashcode != null) {
      getSkills();
    } else {
      // No subcategory selected, clear available skills
      availableSkills.clear();
    }
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

  Future<void> getSkills() async {
    // Get the appropriate category hashcode
    // Use subcategory if selected, otherwise use main category
    final categoryHashcode = selectedSubcategory.value?.hashcode ??
        selectedCategory.value?.hashcode;

    if (categoryHashcode == null) {
      // No category selected, clear skills
      availableSkills.clear();
      return;
    }

    try {
      isLoadingSkills.value = true;

      final response = await _skillsRepository.getSkills(
        category: categoryHashcode,
      );

      if (response.success == true && response.data?.list != null) {
        availableSkills.value = response.data!.list!;
      } else {
        availableSkills.clear();
      }
    } catch (e) {
      print('Error fetching skills: $e');
      availableSkills.clear();
    } finally {
      isLoadingSkills.value = false;
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

  void toggleAreaSelection(AreaModel area) {
    if (isAreaSelected(area)) {
      selectedAreas.removeWhere((a) => a.code == area.code);
    } else {
      selectedAreas.add(area);
    }
  }

  bool isAreaSelected(AreaModel area) {
    return selectedAreas.any((a) => a.code == area.code);
  }

  /// Remote services cover no areas — drop any picked areas when switching to
  /// Remote so nothing stale is sent as `locations`.
  void selectWorkLocationType(String type) {
    selectedWorkLocationType.value = type;
    if (type == 'Remote') selectedAreas.clear();
  }

  /// Off / On header switch (design p107). Applies immediately and rolls back
  /// if the call fails.
  Future<void> setServiceActive(bool active) async {
    if (editServiceHashcode == null || isUpdatingStatus.value) return;
    if (isServiceActive.value == active) return;

    final previous = isServiceActive.value;
    isServiceActive.value = active;
    isUpdatingStatus.value = true;

    try {
      final response = await _serviceStatusRepository.updateServiceStatus(
        editServiceHashcode!,
        active ? 1 : 0,
      );
      if (response.success != true) {
        isServiceActive.value = previous;
        constants.showSnackBar(
          response.message ??
              Resources.of(Get.context!).strings.failedToUpdateServiceStatus,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      isServiceActive.value = previous;
      constants.showSnackBar(
        Resources.of(Get.context!).strings.failedToUpdateServiceStatus,
        SnackBarStatus.ERROR,
      );
    } finally {
      isUpdatingStatus.value = false;
    }
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
          Resources.of(Get.context!).strings.portfolioImageSelectedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorSelectingImage(e.toString()), SnackBarStatus.ERROR);
      print('Error picking portfolio image: $e');
    }
  }

  void removePortfolioImage() {
    portfolioImage.value = null;
    portfolioImageBase64.value = null;
    portfolioImageUrl.value = null;
  }

  Future<void> pickPortfolioFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        portfolioFile.value = file;
        portfolioFileName.value = result.files.single.name;
        portfolioFileSize.value = result.files.single.size;
        portfolioFileExtension.value = result.files.single.extension?.toLowerCase();

        final bytes = await file.readAsBytes();
        final mimeType = _getFileMimeType(portfolioFileExtension.value);
        portfolioFileBase64.value = "data:$mimeType;base64,${base64Encode(bytes)}";

        constants.showSnackBar(
          Resources.of(Get.context!).strings.portfolioImageSelectedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorSelectingCv(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error picking portfolio file: $e');
    }
  }

  void removePortfolioFile() {
    portfolioFile.value = null;
    portfolioFileBase64.value = null;
    portfolioFileName.value = null;
    portfolioFileSize.value = null;
    portfolioFileExtension.value = null;
    portfolioFileUrl.value = null;
  }

  String _getFileMimeType(String? extension) {
    switch (extension) {
      case 'pdf': return 'application/pdf';
      case 'doc': return 'application/msword';
      case 'docx': return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'jpg':
      case 'jpeg': return 'image/jpeg';
      case 'png': return 'image/png';
      default: return 'application/octet-stream';
    }
  }

  IconData getPortfolioFileIcon() {
    switch (portfolioFileExtension.value) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'doc':
      case 'docx': return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png': return Icons.image;
      default: return Icons.insert_drive_file;
    }
  }

  String getFormattedFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  // ---------------------------------------------------------------------------
  // 3-step posting flow: form (1/3) -> Add Skill (2/3) -> Activate (3/3).
  // Prices and caps come from `app/limits`.
  // ---------------------------------------------------------------------------

  static const totalSteps = 3;

  /// True when the member has never published a service — drives the "First
  /// service on us!" promo on the activation step.
  var isFirstService = false.obs;

  AppLimits get limits => AppLimitsCache.current;

  /// Skills beyond the free allowance, billed once.
  int get extraSkillsCount => selectedSkills.length > limits.freeSkills
      ? selectedSkills.length - limits.freeSkills
      : 0;

  double get extraSkillsPrice => extraSkillsCount * limits.extraSkillPrice;

  double get totalToday =>
      (isFirstService.value ? 0 : limits.serviceMonthlyPrice) +
      extraSkillsPrice;

  Future<void> _loadLimits() async {
    await AppLimitsCache.load();
    // The caps feed the Add Skill step, so refresh anything already on screen.
    selectedSkills.refresh();
  }

  /// Counts the member's services; failures leave the promo off.
  Future<void> _checkFirstService() async {
    try {
      final response = await _servicesListRepository.getServices(
        filters: {'member': Prefs.getId},
      );
      if (response.success == true) {
        isFirstService.value = (response.data?.list ?? []).isEmpty;
      }
    } catch (e) {
      print('Error checking previous services: $e');
    }
  }

  /// Step 1 "Continue" — skills are picked on the next step, so they are not
  /// required yet.
  void continueToSkills() {
    if (!validateFields(requireSkills: false)) return;

    Get.toNamed(
      RouteConstant.addSkillScreen,
      arguments: AddSkillArgs(
        availableSkills: availableSkills.toList(),
        selectedSkills: selectedSkills.toList(),
        freeSkills: limits.freeSkills,
        maxSkills: limits.maxSkills,
        extraSkillPrice: limits.extraSkillPrice,
        step: 2,
        totalSteps: totalSteps,
        isLoadingSkills: isLoadingSkills.value,
        onContinue: continueToActivation,
      ),
    );
  }

  /// Step 2 "Continue" — keeps the picked skills and moves on to the fee.
  void continueToActivation(List<Skill> skills) {
    if (skills.isEmpty) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectAtLeastOneSkill,
        SnackBarStatus.ERROR,
      );
      return;
    }

    selectedSkills.value = skills;

    Get.toNamed(
      RouteConstant.activateServiceScreen,
      arguments: ActivateServiceArgs(
        monthlyPrice: limits.serviceMonthlyPrice,
        extraSkillsPrice: extraSkillsPrice,
        extraSkillsCount: extraSkillsCount,
        totalToday: totalToday,
        isFirstService: isFirstService.value,
        step: 3,
        totalSteps: totalSteps,
        onConfirm: addService,
      ),
    );
  }

  /// Closes the whole flow once the service is live.
  void _leaveFlow() {
    Get.until(
      (route) =>
          route.settings.name != RouteConstant.activateServiceScreen &&
          route.settings.name != RouteConstant.addSkillScreen &&
          route.settings.name != RouteConstant.addServiceScreen,
    );
  }

  bool validateFields({bool requireSkills = true}) {
    if (titleController.text.trim().isEmpty) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseEnterTitle, SnackBarStatus.ERROR);
      return false;
    }
    if (selectedCategory.value == null) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseSelectCategory, SnackBarStatus.ERROR);
      return false;
    }
    if (selectedWorkLocationType.value == null) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseSelectJobType, SnackBarStatus.ERROR);
      return false;
    }
    // Remote services cover no areas, so only ask for them on-site/hybrid.
    if (selectedWorkLocationType.value != 'Remote' && selectedAreas.isEmpty) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .pleaseSelectAtLeastOneArea,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (hourlyRateController.text.trim().isEmpty && selectedPricingType.value == Resources.of(Get.context!).strings.hourlyRateOption) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseEnterHourlyRate, SnackBarStatus.ERROR);
      return false;
    }

    if (totalPriceController.text.trim().isEmpty && selectedPricingType.value != Resources.of(Get.context!).strings.hourlyRateOption) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseEnterTotalPrice, SnackBarStatus.ERROR);
      return false;
    }

    if (workExperienceController.text.trim().isEmpty) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .pleaseEnterWorkExperience,
        SnackBarStatus.ERROR,
      );
      return false;
    }
    if (requireSkills && selectedSkills.isEmpty) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .pleaseSelectAtLeastOneSkill,
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
        'title': titleController.text,
        // The form has no separate description field (design p112); the
        // work experience text doubles as the service description.
        'description': workExperienceController.text.trim(),
        'category': categoryHashcode,
        'pricing_type': selectedPricingType.value == Resources.of(Get.context!).strings.hourlyRateOption ? 'U' : 'T',
        'experience': workExperienceController.text,
        'skills': selectedSkills.map((s) => s.hashcode).toList(),
        'locations': selectedAreas.map((a) => a.code).join(','),
        'availability': workingHoursData,
        'work_location_type': workLocationTypeCode,
      };

       if (selectedPricingType.value == Resources.of(Get.context!).strings.hourlyRateOption) {
         data['unit_price'] = hourlyRateController.text.trim();
      }

       if (selectedPricingType.value != Resources.of(Get.context!).strings.hourlyRateOption) {
         data['total_price'] = totalPriceController.text.trim();
      }

      if (portfolioFileBase64.value != null) {
        data['portfolio_file'] = portfolioFileBase64.value!;
      }

      final response = isEditMode.value
          ? await _saveServiceRepository.saveService(editServiceHashcode!, data)
          : await _repository.addService(data);

      if (response.success == true) {
        SuccessSheet.show(
            Get.context!,
            title: isEditMode.value ? Resources
                .of(Get.context!)
                .strings
                .serviceUpdated : Resources
                .of(Get.context!)
                .strings
                .servicePosted,
            image: AppIcons.servicePosted,
            description:
            Resources
                .of(Get.context!)
                .strings
                .yourServiceIsNowLive,
            buttonText: Resources
                .of(Get.context!)
                .strings
                .viewMyServices,
            onButtonPressed: _leaveFlow
        );
      } else {
        constants.showSnackBar(
          response.message ??
              (isEditMode.value
                  ? Resources
                  .of(Get.context!)
                  .strings
                  .failedToUpdateService
                  : Resources
                  .of(Get.context!)
                  .strings
                  .failedToAddService),
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorAddingServiceWithParam(e.toString()), SnackBarStatus.ERROR);
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
