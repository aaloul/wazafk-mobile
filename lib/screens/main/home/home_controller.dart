import 'dart:convert';

import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:wazafak_app/components/sheets/filter_sheet.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/networking/services/wallet/get_wallet_service.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/app/skills_repository.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_job_repository.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_service_repository.dart';
import 'package:wazafak_app/repository/favorite/favorites_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_job_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_service_repository.dart';
import 'package:wazafak_app/repository/home/employer_home_repository.dart';
import 'package:wazafak_app/repository/home/freelancer_home_repository.dart';
import 'package:wazafak_app/repository/member/addresses_repository.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/auth_guard.dart';
import 'package:wazafak_app/utils/pusher_manager.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

class HomeController extends GetxController {
  final _categoriesRepository = CategoriesRepository();
  final _freelancerHomeRepository = FreelancerHomeRepository();
  final _skillsRepository = SkillsRepository();
  final _addressesRepository = AddressesRepository();
  final _getWalletService = GetWalletService();
  final _profileRepository = ProfileRepository();
  final _engagementsListRepository = EngagementsListRepository();
  final _employerHomeRepository = EmployerHomeRepository();
  final _addFavoriteJobRepository = AddFavoriteJobRepository();
  final _removeFavoriteJobRepository = RemoveFavoriteJobRepository();
  final _favoriteMembersRepository = FavoritesRepository();
  final _addFavoriteServiceRepository = AddFavoriteServiceRepository();
  final _removeFavoriteServiceRepository = RemoveFavoriteServiceRepository();
  final _addFavoritePackageRepository = AddFavoritePackageRepository();
  final _removeFavoritePackageRepository = RemoveFavoritePackageRepository();

  var isLoadingCategories = false.obs;
  var isLoadingJobCategories = false.obs;
  var isLoadingJobs = false.obs;
  var isLoadingSkills = false.obs;
  var isLoadingAddresses = false.obs;
  var isLoadingWallet = false.obs;
  var isLoadingProfile = false.obs;
  var isLoadingEngagements = false.obs;
  var isLoadingEmployerHome = false.obs;
  var categories = <Category>[].obs;
  var jobCategories = <Category>[].obs;

  /// Home category bar selection. Tapping a category card highlights it here,
  /// loads its [subcategories] and reloads the feed. `null` means the "All"
  /// state (no category filter).
  var selectedCategory = Rxn<Category>();
  var subcategories = <Category>[].obs;
  var isLoadingSubcategories = false.obs;

  /// Multi-select subcategory chips shown under the selected category. Drives
  /// the `category_list[i]` params sent to the home endpoints.
  var selectedSubcategories = <Category>[].obs;

  var jobs = <Job>[].obs;
  var skills = <Skill>[].obs;
  var addresses = <Address>[].obs;
  var engagements = <Engagement>[].obs;
  var employerData = <Service>[].obs;
  var walletHashcode = ''.obs;
  var walletBalance = ''.obs;

  /// Eye toggle on the profile wallet card — hides the amount for the session.
  var isBalanceHidden = false.obs;

  void toggleBalanceVisibility() =>
      isBalanceHidden.value = !isBalanceHidden.value;
  Rx<User?> profileData = Rx<User?>(null);
  var totalEarnings = ''.obs;
  var nbActiveJobs = 0.obs;
  var nbCompletedJobs = 0.obs;
  var successRate = ''.obs;
  var isFreelancerMode = (Prefs.getUserMode.toString() == 'freelancer').obs;

  var activeFilters = HomeFilters().obs;

  /// Whether the user has explicitly applied filters at least once. Until then
  /// the freelancer home request is sent without any query params.
  var hasAppliedFilters = false;

  void applyFilters(HomeFilters filters) {
    activeFilters.value = filters;
    hasAppliedFilters = true;
    if (isFreelancerMode.value) {
      fetchJobs();
    } else {
      fetchEmployerHome();
    }
  }

  // Unread counts
  var notificationsCount = 0.obs;
  var chatMessagesCount = 0.obs;
  var supportMessagesCount = 0.obs;
  var totalUnreadCount = 0.obs;

  String? selfChannelName;

  @override
  void onInit() {
    super.onInit();
    loadUserModeFromPrefs();
    loadCategoriesFromPrefs();
    loadSkillsFromPrefs();
    if(Prefs.getLoggedIn){
      loadAddressesFromPrefs();
      loadWalletHashcodeFromPrefs();
      fetchProfile();
      fetchAddresses();
      fetchWallet();
    }

    fetchCategories();
    fetchJobCategories();
    fetchSkills();

    // fetchEngagements();

    // Load data based on mode
    if (isFreelancerMode.value) {
      fetchJobs();
    } else {
      fetchEmployerHome();
    }

    // Initialize Pusher for real-time updates
    initPusher();
  }

  @override
  void onClose() {
    // Clean up Pusher subscription
    if (selfChannelName != null && selfChannelName!.isNotEmpty) {
      PusherManager.pusher.unsubscribe(channelName: selfChannelName!);
      PusherManager.channelCallbacks.remove(selfChannelName);
    }
    super.onClose();
  }

  void loadUserModeFromPrefs() {
    isFreelancerMode.value = Prefs.getUserMode == 'freelancer';
  }

  void toggleUserMode(bool isFreelancer) {
    isFreelancerMode.value = isFreelancer;
    Prefs.setUserMode(isFreelancer ? 'freelancer' : 'employer');

    // Job and service categories differ, so drop any category-bar selection
    // and the category hashcodes already pushed into the filters before
    // refreshing, otherwise the new mode is queried with the old mode's
    // category.
    _clearCategorySelection();
    activeFilters.value.category = null;
    activeFilters.value.categories = <Category>[];
    activeFilters.refresh();

    // Reload data based on new mode
    if (isFreelancer) {
      fetchJobs();
    } else {
      fetchEmployerHome();
    }
    // fetchEngagements();
  }

  void loadCategoriesFromPrefs() {
    categories.value = Prefs.getCategories;
  }

  void loadSkillsFromPrefs() {
    skills.value = Prefs.getSkills;
  }

  void loadAddressesFromPrefs() {
    addresses.value = Prefs.getAddresses;
  }

  void loadWalletHashcodeFromPrefs() {
    walletHashcode.value = Prefs.getWalletHashcode;
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;

      final response = await _categoriesRepository.getCategories(type: 'S');

      if (response.success == true && response.data?.list != null) {
        categories.value = response.data!.list!;
        Prefs.setCategories(response.data!.list!);
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load categories',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorLoadingCategories(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error loading categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchJobCategories() async {
    try {
      isLoadingJobCategories.value = true;

      final response = await _categoriesRepository.getCategories(type: 'J');

      if (response.success == true && response.data?.list != null) {
        jobCategories.value = response.data!.list!;
        Prefs.setJobCategories(response.data!.list!);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadCategories,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorLoadingCategories(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error loading categories: $e');
    } finally {
      isLoadingJobCategories.value = false;
    }
  }

  Future<void> fetchJobs() async {
    try {
      isLoadingJobs.value = true;

      final response = await _freelancerHomeRepository.getFreelancerHome(
        filters: hasAppliedFilters ? activeFilters.value.toSearchParams() : null,
      );

      if (response.success == true && response.data != null) {
        jobs.value = response.data?.records ?? [];
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadJobs,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorLoadingJobs(e.toString()), SnackBarStatus.ERROR);
    } finally {
      isLoadingJobs.value = false;
    }
  }

  Future<void> fetchSkills() async {
    try {
      isLoadingSkills.value = true;

      final response = await _skillsRepository.getSkills();

      if (response.success == true && response.data?.list != null) {
        skills.value = response.data!.list!;
        Prefs.setSkills(response.data!.list!);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadSkills,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorLoadingSkills(e.toString()), SnackBarStatus.ERROR);
      print('Error loading skills: $e');
    } finally {
      isLoadingSkills.value = false;
    }
  }

  Future<void> fetchAddresses() async {
    try {
      isLoadingAddresses.value = true;

      final response = await _addressesRepository.getAddresses();

      if (response.success == true && response.data != null) {
        addresses.value = response.data!;
        Prefs.setAddresses(response.data!);
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadAddresses,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorLoadingAddresses(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error loading addresses: $e');
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  Future<void> fetchWallet() async {
    try {
      isLoadingWallet.value = true;

      final response = await _getWalletService.getWallet();

      if (response.success == true && response.data != null) {
        walletHashcode.value = response.data!.hashcode ?? '';
        walletBalance.value = response.data!.balance ?? '';
        Prefs.setWalletHashcode(response.data!.hashcode ?? '');
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadWallet,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorLoadingWallet(e.toString()), SnackBarStatus.ERROR);
      print('Error loading wallet: $e');
    } finally {
      isLoadingWallet.value = false;
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoadingProfile.value = true;

      final response = await _profileRepository.getProfile();

      if (response.success == true && response.data != null) {
        profileData.value = response.data!.member;

        // Update profile statistics
        totalEarnings.value = response.data!.totalEarnings?.toString() ?? '0';
        nbActiveJobs.value = response.data!.nbActiveJobs ?? 0;
        nbCompletedJobs.value = response.data!.nbCompletedJobs ?? 0;
        successRate.value = response.data!.successRate?.toString() ?? '0';


        // Update individual counts
        notificationsCount.value = response.data!.messagingUnreadCounts?.notificationsCount ?? 0;
        chatMessagesCount.value = response.data!.messagingUnreadCounts?.chatMessagesCount?? 0;
        supportMessagesCount.value = response.data!.messagingUnreadCounts?.supportMessagesCount ?? 0;

        // Calculate total
        totalUnreadCount.value =
            chatMessagesCount.value +
                supportMessagesCount.value;


        // Update user preferences with fresh data
        if (response.data!.member != null) {
          final user = response.data!.member!;
          if (user.firstName != null) Prefs.setFName(user.firstName!);
          if (user.lastName != null) Prefs.setLName(user.lastName!);
          if (user.email != null) Prefs.setEmail(user.email!);
          if (user.image != null) Prefs.setAvatar(user.image!);
          if (user.title != null) Prefs.setProfileTitle(user.title.toString());
        }
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadProfile,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorLoadingProfile(e.toString()), SnackBarStatus.ERROR);
      print('Error loading profile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> fetchEngagements() async {
    try {
      isLoadingEngagements.value = true;

      final response = await _engagementsListRepository.getEngagements(
        filters: {
          if (Prefs.getUserMode == 'freelancer') 'freelancer': Prefs.getId,
          if (Prefs.getUserMode == 'employer') 'client': Prefs.getId,
        },
      );

      if (response.success == true && response.data?.list != null) {
        engagements.value = response.data!.list!;
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadTasks,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorLoadingTasks(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error loading engagements: $e');
    } finally {
      isLoadingEngagements.value = false;
    }
  }

  Future<void> fetchEmployerHome() async {
    try {
      isLoadingEmployerHome.value = true;

      final response = await _employerHomeRepository.getEmployerHome(
        filters: hasAppliedFilters ? activeFilters.value.toSearchParams() : null,
      );

      if (response.success == true && response.data != null) {
        // Filter data by entity type
        employerData.value = response.data?.records  ?? [];
      } else {
        constants.showSnackBar(
          response.message ?? Resources
              .of(Get.context!)
              .strings
              .failedToLoadEmployerHomeData,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorLoadingEmployerHomeData(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error loading employer home data: $e');
    } finally {
      isLoadingEmployerHome.value = false;
    }
  }

  Future<bool> toggleJobFavorite(Job job) async {
    if (!requireLogin()) return false;
    if (job.hashcode == null) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .jobInformationNotAvailable,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    try {
      final isFavorite = job.isFavorite ?? false;

      if (isFavorite) {
        // Remove from favorites
        final response = await _removeFavoriteJobRepository.removeFavoriteJob(
          job.hashcode!,
        );

        if (response.success == true) {
          // Update the job's favorite status in the jobs list
          final index = jobs.indexWhere((j) => j.hashcode == job.hashcode);
          if (index != -1) {
            jobs[index].isFavorite = false;
            jobs.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            Resources
                .of(Get.context!)
                .strings
                .removedFromFavorites,
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? Resources
                .of(Get.context!)
                .strings
                .failedToRemoveFromFavorites,
            SnackBarStatus.ERROR,
          );
          return false;
        }
      } else {
        // Add to favorites
        final response = await _addFavoriteJobRepository.addFavoriteJob(
          job.hashcode!,
        );

        if (response.success == true) {
          // Update the job's favorite status in the jobs list
          final index = jobs.indexWhere((j) => j.hashcode == job.hashcode);
          if (index != -1) {
            jobs[index].isFavorite = true;
            jobs.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            Resources
                .of(Get.context!)
                .strings
                .addedToFavorites,
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? Resources
                .of(Get.context!)
                .strings
                .failedToAddToFavorites,
            SnackBarStatus.ERROR,
          );
          return false;
        }
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorUpdatingFavorites(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error toggling favorite: $e');
      return false;
    }
  }

  Future<bool> toggleServiceFavorite(Service service) async {
    if (!requireLogin()) return false;
    if (service.hashcode == null) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .serviceInformationNotAvailable,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    try {
      final isFavorite = service.isFavorite ?? false;

      if (isFavorite) {
        // Remove from favorites
        final response = await _removeFavoriteServiceRepository
            .removeFavoriteService(service.hashcode!);

        if (response.success == true) {
          // Update the service's favorite status in the employerData list
          final index = employerData.indexWhere(
            (data) => data.hashcode == service.hashcode,
          );
          if (index != -1) {
            employerData[index].isFavorite = false;
            employerData.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            response.message ?? Resources
                .of(Get.context!)
                .strings
                .removedFromFavorites,
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? Resources
                .of(Get.context!)
                .strings
                .failedToRemoveFromFavorites,
            SnackBarStatus.ERROR,
          );
          return false;
        }
      } else {
        // Add to favorites
        final response = await _addFavoriteServiceRepository.addFavoriteService(
          service.hashcode!,
        );

        if (response.success == true) {
          // Update the service's favorite status in the employerData list
          final index = employerData.indexWhere(
            (data) => data.hashcode == service.hashcode,
          );
          if (index != -1) {
            employerData[index].isFavorite = true;
            employerData.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            Resources
                .of(Get.context!)
                .strings
                .addedToFavorites,
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? Resources
                .of(Get.context!)
                .strings
                .failedToAddToFavorites,
            SnackBarStatus.ERROR,
          );
          return false;
        }
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating favorites: $e',
        SnackBarStatus.ERROR,
      );
      print('Error toggling service favorite: $e');
      return false;
    }
  }


  Future<void> initPusher() async {
    try {
      // Get the self channel name from preferences
      selfChannelName = Prefs.getSelfChannelName;

      if (selfChannelName == null || selfChannelName!.isEmpty) {
        print('HomeController: Self channel name is empty, skipping Pusher subscription');
        return;
      }

      print('HomeController: Subscribing to channel: $selfChannelName');

      // Set up channel-specific callback for this channel
      PusherManager.channelCallbacks[selfChannelName!] = (PusherEvent event) {
        print('HomeController: Received event on $selfChannelName: ${event.eventName}');
        handlePusherEvent(event);
      };

      // Subscribe to the channel
      await PusherManager.pusher.subscribe(channelName: selfChannelName!);
      print('HomeController: Successfully subscribed to $selfChannelName');
    } catch (e) {
      print('HomeController: Error initializing Pusher: $e');
    }
  }

  void handlePusherEvent(PusherEvent event) {
    print('HomeController: Handling event: ${event.eventName}');
    print('HomeController: Event data: ${event.data}');

    try {
      if (event.eventName == 'MessageUnreadCountUpdated') {
        // Parse the JSON data
        final data = jsonDecode(event.data);

        // Update individual counts
        notificationsCount.value = data['notifications_count'] ?? 0;
        chatMessagesCount.value = data['chat_messages_count'] ?? 0;
        supportMessagesCount.value = data['support_messages_count'] ?? 0;

        // Calculate total
        totalUnreadCount.value =
            chatMessagesCount.value +
            supportMessagesCount.value;

        print('HomeController: Updated unread counts - Total: ${totalUnreadCount.value}');
      }
    } catch (e) {
      print('HomeController: Error parsing event data: $e');
    }
  }

  void onViewAllCategories() {
    Get.toNamed(RouteConstant.allCategoriesScreen);
  }

  // ---------------------------------------------------------------------------
  // Home category bar (select category -> show multi-select subcategories ->
  // refresh the home feed).
  // ---------------------------------------------------------------------------

  /// Tapping a category card. Passing `null` (the "All" card) or re-tapping the
  /// already-selected category clears the selection and reloads unfiltered.
  void onCategorySelected(Category? category) {
    final isClearing = category == null ||
        category.hashcode == selectedCategory.value?.hashcode;

    if (isClearing) {
      _clearCategorySelection();
    } else {
      selectedCategory.value = category;
      selectedSubcategories.clear();
      subcategories.clear();
      fetchSubcategories(category);
    }
    _applyCategoryFilterAndRefresh();
  }

  void _clearCategorySelection() {
    selectedCategory.value = null;
    subcategories.clear();
    selectedSubcategories.clear();
    isLoadingSubcategories.value = false;
  }

  Future<void> fetchSubcategories(Category parent) async {
    if (parent.hashcode == null) return;

    try {
      isLoadingSubcategories.value = true;

      final response = await _categoriesRepository.getCategories(
        parent: parent.hashcode!,
        type: parent.type ?? (isFreelancerMode.value ? 'J' : 'S'),
      );

      // Ignore late responses if the user changed the selection meanwhile.
      if (selectedCategory.value?.hashcode != parent.hashcode) return;

      if (response.success == true && response.data?.list != null) {
        subcategories.value = response.data!.list!;
      } else {
        subcategories.clear();
      }
    } catch (e) {
      if (selectedCategory.value?.hashcode == parent.hashcode) {
        subcategories.clear();
      }
      print('Error loading subcategories: $e');
    } finally {
      if (selectedCategory.value?.hashcode == parent.hashcode) {
        isLoadingSubcategories.value = false;
      }
    }
  }

  /// Toggle a subcategory chip (multi-select) and reload the feed.
  void toggleSubcategory(Category subcategory) {
    final index = selectedSubcategories
        .indexWhere((c) => c.hashcode == subcategory.hashcode);
    if (index >= 0) {
      selectedSubcategories.removeAt(index);
    } else {
      selectedSubcategories.add(subcategory);
    }
    _applyCategoryFilterAndRefresh();
  }

  bool isSubcategorySelected(Category subcategory) =>
      selectedSubcategories.any((c) => c.hashcode == subcategory.hashcode);

  /// Pushes the current category-bar selection into [activeFilters] and reloads
  /// the feed. Selected subcategories are sent as `category_list[i]`; otherwise
  /// the parent category alone is sent as the singular `category` param.
  void _applyCategoryFilterAndRefresh() {
    if (selectedSubcategories.isNotEmpty) {
      activeFilters.value.categories = List<Category>.of(selectedSubcategories);
      activeFilters.value.category = null;
    } else {
      activeFilters.value.categories = <Category>[];
      activeFilters.value.category = selectedCategory.value;
    }
    activeFilters.refresh();
    hasAppliedFilters = true;

    if (isFreelancerMode.value) {
      fetchJobs();
    } else {
      fetchEmployerHome();
    }
  }

  Future<void> refreshHomeData() async {
    // Fetch all data concurrently
    if (Prefs.getLoggedIn) {
      fetchProfile();
      fetchAddresses();
      fetchWallet();
    }

    await Future.wait([
      fetchCategories(),
      fetchJobCategories(),
      fetchSkills(),

      if (isFreelancerMode.value) fetchJobs() else fetchEmployerHome(),
    ]);
  }
}
