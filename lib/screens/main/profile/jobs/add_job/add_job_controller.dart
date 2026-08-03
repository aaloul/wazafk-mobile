import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/LimitsResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/app/limits_repository.dart';
import 'package:wazafak_app/repository/app/skills_repository.dart';
import 'package:wazafak_app/repository/job/add_job_repository.dart';
import 'package:wazafak_app/repository/job/save_job_repository.dart';
import 'package:wazafak_app/screens/main/profile/activation/publish_summary_screen.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/posting_limits.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../../components/sheets/success_sheet.dart';
import '../../../../../utils/res/AppIcons.dart';

class AddJobController extends GetxController {
  final _categoriesRepository = CategoriesRepository();
  final _skillsRepository = SkillsRepository();
  final _addJobRepository = AddJobRepository();
  final _saveJobRepository = SaveJobRepository();

  /// Job Type chips (design p185) — sent to the API as `periodicity`.
  static const periodicityProject = 'PRJ';
  static const periodicityOneTime = 'ONE';

  /// Publish step pricing (design p194) comes from `app/limits`: posts inside
  /// the free allowance cost nothing, everything else is the post fee. Skills
  /// aren't billed on a job. Reactive so the banner and totals update once the
  /// call lands.
  final limits = AppLimitsCache.current.obs;

  EntityLimit get jobLimit => limits.value.job;

  Job? editingJob;

  final titleController = TextEditingController();
  final totalPriceController = TextEditingController();
  final overviewController = TextEditingController();
  final responsibilitiesController = TextEditingController();
  final requirementsController = TextEditingController();

  var selectedCategory = Rxn<Category>();
  var selectedSubcategory = Rxn<Category>();
  var subcategories = <Category>[].obs;
  var isLoadingSubcategories = false.obs;
  var categorySkills = <Skill>[].obs;
  var isLoadingSkills = false.obs;
  var selectedSkills = <Skill>[].obs;
  var selectedAddress = Rxn<Address>();
  var selectedJobType = Rxn<String>();

  /// Project / One time (design p185). Holds [periodicityProject] or
  /// [periodicityOneTime].
  var selectedPeriodicity = Rxn<String>();

  /// Drives the free first post on the publish step — the backend tells us
  /// whether this post is billable.
  bool get isFirstJobPost => !jobLimit.chargeable;

  /// The free-post banner waits for `app/limits`, so it never flashes on a
  /// post that turns out to be chargeable.
  ///
  /// [limits] is read first on purpose: this runs inside an `Obx`, and a
  /// short-circuit on [AppLimitsCache.isLoaded] would leave that build with no
  /// observable to subscribe to.
  bool get showFreePostBanner {
    final withinAllowance = isFirstJobPost;
    return AppLimitsCache.isLoaded && withinAllowance;
  }

  /// Free posts still available — `free_limit` minus what's been used, falling
  /// back to the allowance itself when the backend reports none used.
  int get freeJobPostsLeft => jobLimit.remainingFree > 0
      ? jobLimit.remainingFree
      : jobLimit.freeLimit;
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
      // On-site is the default Location pick.
      selectedJobType.value = 'Onsite';
    }
    _loadLimits();
  }

  Future<AppLimits>? _limitsRequest;

  /// Re-fetched every time the screen opens so allowances and prices are
  /// current; the in-flight call is reused by the steps that wait on it.
  Future<void> _loadLimits() async {
    _limitsRequest = AppLimitsCache.load(forceRefresh: true);
    limits.value = await _limitsRequest!;
  }

  Future<void> _ensureLimits() async {
    if (_limitsRequest != null) {
      limits.value = await _limitsRequest!;
      return;
    }
    await _loadLimits();
  }

  /// A job post is billed on its own — skills carry no charge here.
  double get totalToday => isFirstJobPost ? 0 : jobLimit.price;

  Future<void> _populateFormForEditing() async {
    if (editingJob == null) return;

    // Reset category selections
    selectedCategory.value = null;
    selectedSubcategory.value = null;
    subcategories.clear();

    // Populate text fields
    titleController.text = editingJob!.title ?? '';
    totalPriceController.text = editingJob!.totalPrice ?? '';
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

    // Set job type (Project / One time)
    final periodicity = editingJob!.periodicity;
    if (periodicity == periodicityProject || periodicity == periodicityOneTime) {
      selectedPeriodicity.value = periodicity;
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
    totalPriceController.dispose();
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
      // Load skills for the main category
      await loadSkillsByCategory(category.hashcode!);
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

  Future<void> loadSkillsByCategory(String categoryHashcode) async {
    try {
      isLoadingSkills.value = true;
      categorySkills.clear();

      final response = await _skillsRepository.getSkills(
        category: categoryHashcode,
      );

      if (response.success == true && response.data != null) {
        categorySkills.value = response.data!.list ?? [];
        print(
          'Loaded ${categorySkills.length} skills for category $categoryHashcode',
        );
      } else {
        print('Failed to load skills: ${response.message}');
      }
    } catch (e) {
      print('Error loading skills: $e');
    } finally {
      isLoadingSkills.value = false;
    }
  }

  Future<void> selectSubcategory(Category subcategory) async {
    selectedSubcategory.value = subcategory;

    // Load skills for the subcategory
    if (subcategory.hashcode != null) {
      await loadSkillsByCategory(subcategory.hashcode!);
    }
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
    // Remote jobs carry no address.
    if (jobType == 'Remote') selectedAddress.value = null;
  }

  void selectPeriodicity(String periodicity) {
    selectedPeriodicity.value = periodicity;
  }

  /// "Continue" on the form (design p185 step 1/2) — validates, then hands over
  /// to the publish screen which confirms the fee and posts the job.
  ///
  /// Waits for `app/limits` first: until it answers the fallbacks report the
  /// post as free, which would show the wrong total.
  Future<void> continueToPublish() async {
    if (!_validate()) return;

    isLoading.value = true;
    await _ensureLimits();
    isLoading.value = false;

    final strings = Resources.of(Get.context!).strings;
    Get.toNamed(
      RouteConstant.publishSummaryScreen,
      arguments: PublishSummaryArgs(
        labels: PublishSummaryLabels(
          title: strings.publishLabel,
          feeLabel: strings.jobPostFee,
          promoTitle: strings.firstJobPostOnUs,
          promoSubtitle: strings.publishInstantly,
          promoLabel: strings.firstJobPostPromo,
          afterNote: strings.afterThisJobCostsAmount,
          shortfallNote: strings.jobPostShortfallNote,
          confirmLabel: strings.publishLabel,
          topUpConfirmLabel: strings.topUpAndPublish,
          editLabel: strings.editDetails,
        ),
        fee: jobLimit.price,
        totalToday: totalToday,
        isFirst: isFirstJobPost,
        step: 2,
        totalSteps: 2,
        onConfirm: addJob,
        onEdit: () => Get.back(),
      ),
    );
  }

  /// Closes the posting flow (form + publish step) once the job is live.
  void _leaveFlow() {
    Get.until(
      (route) =>
          route.settings.name != RouteConstant.publishSummaryScreen &&
          route.settings.name != RouteConstant.addJobScreen,
    );
  }

  /// Form validation shared by "Continue" (add) and "Post Job" (edit).
  bool _validate() {
    if (titleController.text.trim().isEmpty) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseEnterJobTitle,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (selectedCategory.value == null) {
      print('Validation failed: selectedCategory is null');
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectCategory,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (selectedJobType.value == null) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectLocationType,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (selectedJobType.value != 'Remote' && selectedAddress.value == null) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectLocation,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (selectedPeriodicity.value == null) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectJobType,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (selectedDate.value == null) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectStartDate,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (selectedTime.value == null) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectStartTime,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    // Expiry is optional, but a half-filled or backwards one is not.
    final expiryDate = selectedExpiryDate.value;
    final expiryTime = selectedExpiryTime.value;
    if ((expiryDate == null) != (expiryTime == null)) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseCompleteExpiryDateTime,
        SnackBarStatus.ERROR,
      );
      return false;
    }
    if (expiryDate != null && expiryTime != null) {
      final start = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );
      final expiry = DateTime(
        expiryDate.year,
        expiryDate.month,
        expiryDate.day,
        expiryTime.hour,
        expiryTime.minute,
      );
      if (!expiry.isAfter(start)) {
        constants.showSnackBar(
          Resources.of(Get.context!).strings.expiryMustBeAfterStart,
          SnackBarStatus.ERROR,
        );
        return false;
      }
    }

    if (totalPriceController.text.trim().isEmpty) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseEnterHourlyRate,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (selectedSkills.isEmpty) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseSelectAtLeastOneSkill,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (overviewController.text.trim().isEmpty) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseEnterOverview,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (responsibilitiesController.text.trim().isEmpty) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseEnterResponsibilities,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    if (requirementsController.text.trim().isEmpty) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseEnterRequirements,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    return true;
  }

  /// API datetime format — `2025-10-05 10:00` (24h, zero-padded, ASCII digits
  /// regardless of the app language).
  static String _formatApiDateTime(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year.toString().padLeft(4, '0')}-${two(value.month)}-${two(value.day)} '
        '${two(value.hour)}:${two(value.minute)}';
  }

  Future<void> addJob() async {
    if (!_validate()) return;

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

      final formattedStartDateTime = _formatApiDateTime(startDateTime);

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
        formattedExpiryDateTime = _formatApiDateTime(expiryDateTime);
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
        'unit_price': null,
        'total_price': totalPriceController.text.trim(),
        'overview': overviewController.text.trim(),
        'responsibilities': responsibilitiesController.text.trim(),
        'requirememts': requirementsController.text.trim(),
        'work_location_type': workLocationType,
        if(selectedAddress.value != null)
        'address': selectedAddress.value!.hashcode,
        'start_datetime': formattedStartDateTime,
        'skills': selectedSkills.map((s) => s.hashcode).toList(),
        "image": "",
        "tasks_milestones": '',
        "periodicity": selectedPeriodicity.value ?? '',
        "expiry_datetime": formattedExpiryDateTime,
        "description": '',
      };

      final response = editingJob != null
          ? await _saveJobRepository.saveJob(editingJob!.hashcode!, data)
          : await _addJobRepository.addJob(data);

      if (response.success == true) {
        // The allowance and the wallet just changed — refresh both.
        AppLimitsCache.load(forceRefresh: true).then(
          (value) => limits.value = value,
        );
        PostingLimits.refreshWallet();
        SuccessSheet.show(
          Get.context!,
          title: isEditMode
              ? Resources.of(Get.context!).strings.jobUpdated
              : Resources.of(Get.context!).strings.jobPosted,
          image: AppIcons.servicePosted,
          description: Resources.of(Get.context!).strings.yourJobIsNowLive,
          buttonText: Resources.of(Get.context!).strings.viewMyJobs,
          onButtonPressed: _leaveFlow,
        );
      } else {
        constants.showSnackBar(
          response.message ??
              (editingJob != null
                  ? Resources.of(Get.context!).strings.errorUpdatingJob
                  : Resources.of(Get.context!).strings.errorPostingJob),
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        editingJob != null
            ? Resources.of(
                Get.context!,
              ).strings.errorUpdatingJobWithParam(e.toString())
            : Resources.of(
                Get.context!,
              ).strings.errorPostingJobWithParam(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool get isEditMode => editingJob != null;
}
