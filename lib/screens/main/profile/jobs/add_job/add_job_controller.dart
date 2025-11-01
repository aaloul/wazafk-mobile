import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/job/add_job_repository.dart';
import 'package:wazafak_app/repository/job/save_job_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../../components/sheets/success_sheet.dart';
import '../../../../../utils/res/AppIcons.dart';

class AddJobController extends GetxController {
  final _categoriesRepository = CategoriesRepository();
  final _addJobRepository = AddJobRepository();
  final _saveJobRepository = SaveJobRepository();

  Job? editingJob;

  final titleController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final overviewController = TextEditingController();
  final responsibilitiesController = TextEditingController();
  final requirementsController = TextEditingController();

  var selectedCategory = Rxn<Category>();
  var selectedSubcategory = Rxn<Category>();
  var subcategories = <Category>[].obs;
  var isLoadingSubcategories = false.obs;
  var selectedSkills = <Skill>[].obs;
  var selectedAddress = Rxn<Address>();
  var selectedJobType = Rxn<String>();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  var selectedExpiryDate = Rxn<DateTime>();
  var selectedExpiryTime = Rxn<TimeOfDay>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Check if we're editing an existing job
    if (Get.arguments != null && Get.arguments is Job) {
      editingJob = Get.arguments as Job;
      _populateFormForEditing();
    } else {
      // Ensure category is null on initialization
      selectedCategory.value = null;
      selectedSubcategory.value = null;
    }
  }

  Future<void> _populateFormForEditing() async {
    if (editingJob == null) return;

    // Reset category selections
    selectedCategory.value = null;
    selectedSubcategory.value = null;
    subcategories.clear();

    // Populate text fields
    titleController.text = editingJob!.title ?? '';
    hourlyRateController.text = editingJob!.unitPrice ?? '';
    overviewController.text = editingJob!.overview ?? '';
    responsibilitiesController.text = editingJob!.responsibilities ?? '';
    requirementsController.text = editingJob!.requirememts ?? '';

    // Set address
    if (editingJob!.address != null) {
      selectedAddress.value = editingJob!.address;
    }

    // Set job type from work location type
    switch (editingJob!.workLocationType) {
      case 'RMT':
        selectedJobType.value = 'Remote';
        break;
      case 'HYB':
        selectedJobType.value = 'Hybrid';
        break;
      case 'SIT':
        selectedJobType.value = 'Onsite';
        break;
    }

    // Set date and time
    if (editingJob!.startDatetime != null) {
      selectedDate.value = editingJob!.startDatetime;
      selectedTime.value = TimeOfDay(
        hour: editingJob!.startDatetime!.hour,
        minute: editingJob!.startDatetime!.minute,
      );
    }

    // Set expiry date and time
    if (editingJob!.expiryDatetime != null) {
      selectedExpiryDate.value = editingJob!.expiryDatetime;
      selectedExpiryTime.value = TimeOfDay(
        hour: editingJob!.expiryDatetime!.hour,
        minute: editingJob!.expiryDatetime!.minute,
      );
    }

    // Set skills
    if (editingJob!.skills != null) {
      selectedSkills.value = editingJob!.skills!;
    }

    // Set category - find from Prefs job categories list
    if (editingJob!.parentCategoryHashcode == null) {
      // No parent category, so this is a main category
      final category = Prefs.getJobCategories.firstWhereOrNull(
        (cat) => cat.hashcode == editingJob!.categoryHashcode,
      );

      if (category != null) {
        selectedCategory.value = category;
      }
    } else {
      // Has parent category, so we need to select both parent and subcategory
      final category = Prefs.getJobCategories.firstWhereOrNull(
        (cat) => cat.hashcode == editingJob!.parentCategoryHashcode,
      );

      if (category != null) {
        selectedCategory.value = category;
      }

      // Load subcategories
      await loadSubcategories(editingJob!.parentCategoryHashcode!);

      // Select the subcategory
      selectedSubcategory.value = subcategories.firstWhereOrNull(
        (cat) => cat.hashcode == editingJob!.categoryHashcode,
      );
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    hourlyRateController.dispose();
    overviewController.dispose();
    responsibilitiesController.dispose();
    requirementsController.dispose();
    super.onClose();
  }

  Future<void> selectCategory(Category category) async {
    selectedCategory.value = category;
    selectedSubcategory.value = null;
    subcategories.clear();

    print(
      'Category selected: ${category.name}, hashcode: ${category.hashcode}',
    );

    // Load subcategories
    if (category.hashcode != null) {
      await loadSubcategories(category.hashcode!);
    }
  }

  Future<void> loadSubcategories(String parentHashcode) async {
    try {
      isLoadingSubcategories.value = true;
      final response = await _categoriesRepository.getCategories(
        parent: parentHashcode,
        type: 'J',
      );

      if (response.success == true && response.data != null) {
        subcategories.value = response.data!.list ?? [];
      }
    } catch (e) {
      // Error loading subcategories
    } finally {
      isLoadingSubcategories.value = false;
    }
  }

  void selectSubcategory(Category subcategory) {
    selectedSubcategory.value = subcategory;
  }

  void toggleSkill(Skill skill) {
    if (isSkillSelected(skill)) {
      selectedSkills.removeWhere((s) => s.hashcode == skill.hashcode);
    } else {
      selectedSkills.add(skill);
    }
  }

  bool isSkillSelected(Skill skill) {
    return selectedSkills.any((s) => s.hashcode == skill.hashcode);
  }

  void selectAddress(Address address) {
    selectedAddress.value = address;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void selectExpiryDate(DateTime date) {
    selectedExpiryDate.value = date;
  }

  void selectExpiryTime(TimeOfDay time) {
    selectedExpiryTime.value = time;
  }

  void selectJobType(String jobType) {
    selectedJobType.value = jobType;
  }

  Future<void> addJob() async {
    // Validate form
    if (titleController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter job title', SnackBarStatus.ERROR);
      return;
    }

    if (selectedAddress.value == null) {
      constants.showSnackBar('Please select a location', SnackBarStatus.ERROR);
      return;
    }

    if (selectedCategory.value == null) {
      print('Validation failed: selectedCategory is null');
      constants.showSnackBar('Please select a category', SnackBarStatus.ERROR);
      return;
    }

    print(
      'Validation passed: selectedCategory = ${selectedCategory.value?.name}',
    );

    if (selectedJobType.value == null) {
      constants.showSnackBar('Please select a job type', SnackBarStatus.ERROR);
      return;
    }

    if (selectedDate.value == null) {
      constants.showSnackBar(
        'Please select a start date',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (selectedTime.value == null) {
      constants.showSnackBar(
        'Please select a start time',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (hourlyRateController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter hourly rate', SnackBarStatus.ERROR);
      return;
    }

    if (selectedSkills.isEmpty) {
      constants.showSnackBar(
        'Please select at least one skill',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (overviewController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter overview', SnackBarStatus.ERROR);
      return;
    }

    if (responsibilitiesController.text.trim().isEmpty) {
      constants.showSnackBar(
        'Please enter responsibilities',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (requirementsController.text.trim().isEmpty) {
      constants.showSnackBar('Please enter requirements', SnackBarStatus.ERROR);
      return;
    }

    try {
      isLoading.value = true;

      // Combine date and time for start_datetime
      final startDateTime = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );

      // Format datetime as "YYYY-MM-DD HH:MM"
      final formattedStartDateTime =
          '${startDateTime.year}-${startDateTime.month.toString().padLeft(2, '0')}-${startDateTime.day.toString().padLeft(2, '0')} '
          '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}';

      // Format expiry datetime if provided
      String formattedExpiryDateTime = '';
      if (selectedExpiryDate.value != null &&
          selectedExpiryTime.value != null) {
        final expiryDateTime = DateTime(
          selectedExpiryDate.value!.year,
          selectedExpiryDate.value!.month,
          selectedExpiryDate.value!.day,
          selectedExpiryTime.value!.hour,
          selectedExpiryTime.value!.minute,
        );
        formattedExpiryDateTime =
            '${expiryDateTime.year}-${expiryDateTime.month.toString().padLeft(2, '0')}-${expiryDateTime.day.toString().padLeft(2, '0')} '
            '${expiryDateTime.hour.toString().padLeft(2, '0')}:${expiryDateTime.minute.toString().padLeft(2, '0')}';
      }

      // Map work location type to API codes
      String workLocationType = '';
      switch (selectedJobType.value) {
        case 'Remote':
          workLocationType = 'RMT';
          break;
        case 'Hybrid':
          workLocationType = 'HYB';
          break;
        case 'Onsite':
          workLocationType = 'SIT';
          break;
      }

      Map<String, dynamic> data = {
        'category':
            selectedSubcategory.value?.hashcode ??
            selectedCategory.value!.hashcode,
        'title': titleController.text.trim(),
        'unit_price': hourlyRateController.text.trim(),
        'total_price': hourlyRateController.text.trim(),
        'overview': overviewController.text.trim(),
        'responsibilities': responsibilitiesController.text.trim(),
        'requirememts': requirementsController.text.trim(),
        'work_location_type': workLocationType,
        'address': selectedAddress.value!.hashcode,
        'start_datetime': formattedStartDateTime,
        'skills': selectedSkills.map((s) => s.hashcode).toList(),
        "image": "",
        "tasks_milestones": '',
        "periodicity": '',
        "expiry_datetime": formattedExpiryDateTime,
        "description": '',
      };

      final response = editingJob != null
          ? await _saveJobRepository.saveJob(editingJob!.hashcode!, data)
          : await _addJobRepository.addJob(data);

      if (response.success == true) {
        SuccessSheet.show(
            Get.context!,
            title: isEditMode ? 'Job Updated' : 'Job Posted',
            image: AppIcons.servicePosted,
            description:
            'Your Job is now live! Keep an eye out for opportunities.',
            buttonText: 'View Profile',
            onButtonPressed: () {
              Navigator.pop(Get.context!);
            }
        );
      } else {
        constants.showSnackBar(
          response.message ??
              (editingJob != null ? 'Error updating job' : 'Error posting job'),
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        editingJob != null ? 'Error updating job: $e' : 'Error posting job: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool get isEditMode => editingJob != null;
}
