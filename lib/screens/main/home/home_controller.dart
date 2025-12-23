import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/EmployerHomeResponse.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
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
  var jobs = <Job>[].obs;
  var skills = <Skill>[].obs;
  var addresses = <Address>[].obs;
  var engagements = <Engagement>[].obs;
  var employerData = <EmployerHomeData>[].obs;
  var walletHashcode = ''.obs;
  var walletBalance = ''.obs;
  Rx<User?> profileData = Rx<User?>(null);
  var totalEarnings = ''.obs;
  var nbActiveJobs = 0.obs;
  var nbCompletedJobs = 0.obs;
  var successRate = ''.obs;
  var isFreelancerMode = (Prefs.getUserMode.toString() == 'freelancer').obs;

  @override
  void onInit() {
    super.onInit();
    loadUserModeFromPrefs();
    loadCategoriesFromPrefs();
    loadSkillsFromPrefs();
    loadAddressesFromPrefs();
    loadWalletHashcodeFromPrefs();
    fetchProfile();
    fetchCategories();
    fetchJobCategories();
    fetchSkills();
    fetchAddresses();
    fetchWallet();
    fetchEngagements();

    // Load data based on mode
    if (isFreelancerMode.value) {
      fetchJobs();
    } else {
      fetchEmployerHome();
    }
  }

  void loadUserModeFromPrefs() {
    isFreelancerMode.value = Prefs.getUserMode == 'freelancer';
  }

  void toggleUserMode(bool isFreelancer) {
    isFreelancerMode.value = isFreelancer;
    Prefs.setUserMode(isFreelancer ? 'freelancer' : 'employer');

    // Reload data based on new mode
    if (isFreelancer) {
      fetchJobs();
    } else {
      fetchEmployerHome();
    }
    fetchEngagements();
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

      final response = await _freelancerHomeRepository.getFreelancerHome();

      if (response.success == true && response.data != null) {
        jobs.value = response.data!;
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
              .failedToLoadEngagements,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorLoadingEngagements(e.toString()),
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

      final response = await _employerHomeRepository.getEmployerHome();

      if (response.success == true && response.data != null) {
        // Filter data by entity type
        employerData.value = response.data?.records ?? [];
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

  Future<bool> toggleMemberFavorite(User member) async {
    if (member.hashcode == null) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .memberInformationNotAvailable,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    try {
      final isFavorite = member.isFavorite == 1;

      if (isFavorite) {
        // Remove from favorites
        final response = await _favoriteMembersRepository.removeFavoriteMember(
          member.hashcode!,
        );

        if (response.success == true) {
          // Update the member's favorite status in the employerData list
          final index = employerData.indexWhere(
            (data) => data.member?.hashcode == member.hashcode,
          );
          if (index != -1 && employerData[index].member != null) {
            employerData[index].member!.isFavorite = 0;
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
        final response = await _favoriteMembersRepository.addFavoriteMember(
          member.hashcode!,
        );

        if (response.success == true) {
          // Update the member's favorite status in the employerData list
          final index = employerData.indexWhere(
            (data) => data.member?.hashcode == member.hashcode,
          );
          if (index != -1 && employerData[index].member != null) {
            employerData[index].member!.isFavorite = 1;
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
      print('Error toggling member favorite: $e');
      return false;
    }
  }

  Future<bool> toggleServiceFavorite(Service service) async {
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
            (data) => data.service?.hashcode == service.hashcode,
          );
          if (index != -1 && employerData[index].service != null) {
            employerData[index].service!.isFavorite = false;
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
            (data) => data.service?.hashcode == service.hashcode,
          );
          if (index != -1 && employerData[index].service != null) {
            employerData[index].service!.isFavorite = true;
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

  Future<bool> togglePackageFavorite(Package package) async {
    if (package.hashcode == null) {
      constants.showSnackBar(
        'Package information not available',
        SnackBarStatus.ERROR,
      );
      return false;
    }

    try {
      final isFavorite = package.isFavorite ?? false;

      if (isFavorite) {
        // Remove from favorites
        final response = await _removeFavoritePackageRepository
            .removeFavoritePackage(package.hashcode!);

        if (response.success == true) {
          // Update the package's favorite status in the employerData list
          final index = employerData.indexWhere(
            (data) => data.package?.hashcode == package.hashcode,
          );
          if (index != -1 && employerData[index].package != null) {
            employerData[index].package!.isFavorite = false;
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
        final response = await _addFavoritePackageRepository.addFavoritePackage(
          package.hashcode!,
        );

        if (response.success == true) {
          // Update the package's favorite status in the employerData list
          final index = employerData.indexWhere(
            (data) => data.package?.hashcode == package.hashcode,
          );
          if (index != -1 && employerData[index].package != null) {
            employerData[index].package!.isFavorite = true;
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
      print('Error toggling package favorite: $e');
      return false;
    }
  }

  void onViewAllCategories() {
    Get.toNamed(RouteConstant.allCategoriesScreen);
  }

  Future<void> refreshHomeData() async {
    // Fetch all data concurrently
    await Future.wait([
      fetchProfile(),
      fetchCategories(),
      fetchJobCategories(),
      fetchSkills(),
      fetchAddresses(),
      fetchWallet(),
      fetchEngagements(),
      if (isFreelancerMode.value) fetchJobs() else fetchEmployerHome(),
    ]);
  }
}
