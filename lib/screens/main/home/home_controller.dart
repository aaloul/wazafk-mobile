import 'package:get/get.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/repository/job/jobs_list_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

class HomeController extends GetxController {
  final _categoriesRepository = CategoriesRepository();
  final _jobsRepository = JobsListRepository();

  var isLoadingCategories = false.obs;
  var isLoadingJobs = false.obs;
  var categories = <Category>[].obs;
  var jobs = <Job>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategoriesFromPrefs();
    fetchCategories();
    fetchJobs();
  }

  void loadCategoriesFromPrefs() {
    categories.value = Prefs.getCategories;
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

  @override
  void onClose() {
    super.onClose();
  }
}
