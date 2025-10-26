import 'package:get/get.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/EmployerHomeResponse.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/networking/services/wallet/get_wallet_service.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/app/skills_repository.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/repository/home/employer_home_repository.dart';
import 'package:wazafak_app/repository/home/freelancer_home_repository.dart';
import 'package:wazafak_app/repository/member/addresses_repository.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
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
  var freelancers = <HomeFreelancer>[].obs;
  var walletHashcode = ''.obs;
  Rx<User?> profileData = Rx<User?>(null);
  var totalEarnings = ''.obs;
  var nbActiveJobs = 0.obs;
  var nbCompletedJobs = 0.obs;
  var successRate = ''.obs;
  var isFreelancerMode = true.obs;

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

      final response = await _categoriesRepository.getCategories(
          type: 'S'
      );

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
        'Error loading categories: $e',
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

      final response = await _categoriesRepository.getCategories(
          type: 'J'
      );

      if (response.success == true && response.data?.list != null) {
        jobCategories.value = response.data!.list!;
        Prefs.setJobCategories(response.data!.list!);
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load categories',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error loading categories: $e',
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
          response.message ?? 'Failed to load jobs',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error loading jobs: $e', SnackBarStatus.ERROR);
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
          response.message ?? 'Failed to load skills',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error loading skills: $e', SnackBarStatus.ERROR);
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
          response.message ?? 'Failed to load addresses',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
          'Error loading addresses: $e', SnackBarStatus.ERROR);
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
        Prefs.setWalletHashcode(response.data!.hashcode ?? '');
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load wallet',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error loading wallet: $e', SnackBarStatus.ERROR);
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
          response.message ?? 'Failed to load profile',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error loading profile: $e', SnackBarStatus.ERROR);
      print('Error loading profile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> fetchEngagements() async {
    try {
      isLoadingEngagements.value = true;

      final response = await _engagementsListRepository.getEngagements();

      if (response.success == true && response.data?.list != null) {
        engagements.value = response.data!.list!;
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load engagements',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error loading engagements: $e',
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
        freelancers.value = response.data!;
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load freelancers',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error loading freelancers: $e',
        SnackBarStatus.ERROR,
      );
      print('Error loading freelancers: $e');
    } finally {
      isLoadingEmployerHome.value = false;
    }
  }
}
