import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/EmployerHomeResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/repository/search/employer_search_repository.dart';
import 'package:wazafak_app/repository/search/freelancer_search_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FreelancerSearchRepository _freelancerSearchRepository =
      FreelancerSearchRepository();
  final EmployerSearchRepository _employerSearchRepository =
      EmployerSearchRepository();

  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var selectedCategory = Rxn<Category>();

  // Results for different types
  var jobResults = <Job>[].obs;
  var employerResults = <EmployerHomeData>[].obs;

  bool get isFreelancerMode => Prefs.getUserMode == 'freelancer';

  @override
  void onInit() {
    super.onInit();

    // Get category from arguments if provided
    if (Get.arguments != null && Get.arguments is Category) {
      selectedCategory.value = Get.arguments as Category;
    }

    search('');
  }

  Future<void> search(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      jobResults.clear();
      employerResults.clear();
      return;
    }

    try {
      isLoading.value = true;

      Map<String, String> filters = {'query': query};

      // Add category filter if selected
      if (selectedCategory.value?.hashcode != null) {
        filters['category'] = selectedCategory.value!.hashcode!;
      }

      if (isFreelancerMode) {
        // Freelancer mode: search for jobs
        final response = await _freelancerSearchRepository.freelancerSearch(
          filters: filters,
        );

        if (response.success == true && response.data != null) {
          jobResults.value = response.data!;
        } else {
          jobResults.clear();
          if (response.message != null) {
            constants.showSnackBar(response.message!, SnackBarStatus.ERROR);
          }
        }
      } else {
        // Employer mode: search for services, packages, and freelancers
        final response = await _employerSearchRepository.employerSearch(
          filters: filters,
        );

        if (response.success == true && response.data != null) {
          employerResults.value = response.data!;
        } else {
          employerResults.clear();
          if (response.message != null) {
            constants.showSnackBar(response.message!, SnackBarStatus.ERROR);
          }
        }
      }
    } catch (e) {
      constants.showSnackBar('Error searching: $e', SnackBarStatus.ERROR);
      print('Error searching: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
