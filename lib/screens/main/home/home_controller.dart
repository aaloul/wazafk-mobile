import 'package:get/get.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/networking/services/wallet/get_wallet_service.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/app/skills_repository.dart';
import 'package:wazafak_app/repository/job/jobs_list_repository.dart';
import 'package:wazafak_app/repository/member/addresses_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

class HomeController extends GetxController {
  final _categoriesRepository = CategoriesRepository();
  final _jobsRepository = JobsListRepository();
  final _skillsRepository = SkillsRepository();
  final _addressesRepository = AddressesRepository();
  final _getWalletService = GetWalletService();

  var isLoadingCategories = false.obs;
  var isLoadingJobs = false.obs;
  var isLoadingSkills = false.obs;
  var isLoadingAddresses = false.obs;
  var isLoadingWallet = false.obs;
  var categories = <Category>[].obs;
  var jobs = <Job>[].obs;
  var skills = <Skill>[].obs;
  var addresses = <Address>[].obs;
  var walletHashcode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategoriesFromPrefs();
    loadSkillsFromPrefs();
    loadAddressesFromPrefs();
    loadWalletHashcodeFromPrefs();
    fetchCategories();
    fetchJobs();
    fetchSkills();
    fetchAddresses();
    fetchWallet();
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

      final response = await _categoriesRepository.getCategories();

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

  Future<void> fetchJobs() async {
    try {
      isLoadingJobs.value = true;

      final response = await _jobsRepository.getJobs();

      if (response.success == true && response.data?.list != null) {
        jobs.value = response.data!.list!;
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load jobs',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error loading jobs: $e', SnackBarStatus.ERROR);
      print('Error loading jobs: $e');
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

  @override
  void onClose() {
    super.onClose();
  }
}
