import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/SearchResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_job_repository.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_service_repository.dart';
import 'package:wazafak_app/repository/favorite/favorites_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_job_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_service_repository.dart';
import 'package:wazafak_app/repository/search/employer_search_repository.dart';
import 'package:wazafak_app/repository/search/freelancer_search_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FreelancerSearchRepository _freelancerSearchRepository =
      FreelancerSearchRepository();
  final EmployerSearchRepository _employerSearchRepository =
      EmployerSearchRepository();
  final _addFavoriteJobRepository = AddFavoriteJobRepository();
  final _removeFavoriteJobRepository = RemoveFavoriteJobRepository();
  final _favoriteMembersRepository = FavoritesRepository();
  final _addFavoriteServiceRepository = AddFavoriteServiceRepository();
  final _removeFavoriteServiceRepository = RemoveFavoriteServiceRepository();
  final _addFavoritePackageRepository = AddFavoritePackageRepository();
  final _removeFavoritePackageRepository = RemoveFavoritePackageRepository();

  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var selectedCategory = Rxn<Category>();

  // Results for different types
  var searchResults = <SearchData>[].obs;

  // Pagination
  var currentPage = 1.obs;
  var hasMorePages = true.obs;
  var totalResults = 0.obs;

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
      searchResults.clear();
      currentPage.value = 1;
      hasMorePages.value = true;
      totalResults.value = 0;
      return;
    }

    try {
      isLoading.value = true;
      currentPage.value = 1; // Reset to first page
      hasMorePages.value = true;

      Map<String, String> filters = {
        'query': query,
        'page': '1',
      };

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
          searchResults.value = response.data?.records ?? [];
          totalResults.value = response.data?.total ?? 0;

          // Check if there are more pages
          final currentPageNum = response.data?.page ?? 1;
          final pageLimit = response.data?.pageLimit ?? 0;
          hasMorePages.value = (searchResults.length < totalResults.value) &&
              (pageLimit > 0 && searchResults.length >= pageLimit);
        } else {
          searchResults.clear();
          hasMorePages.value = false;
          totalResults.value = 0;
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
          searchResults.value = response.data?.records ?? [];
          totalResults.value = response.data?.total ?? 0;

          // Check if there are more pages
          final currentPageNum = response.data?.page ?? 1;
          final pageLimit = response.data?.pageLimit ?? 0;
          hasMorePages.value = (searchResults.length < totalResults.value) &&
              (pageLimit > 0 && searchResults.length >= pageLimit);
        } else {
          searchResults.clear();
          hasMorePages.value = false;
          totalResults.value = 0;
          if (response.message != null) {
            constants.showSnackBar(response.message!, SnackBarStatus.ERROR);
          }
        }
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorSearching(e.toString()), SnackBarStatus.ERROR);
      print('Error searching: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMorePages.value ||
        searchQuery.value.isEmpty) {
      return;
    }

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      Map<String, String> filters = {
        'query': searchQuery.value,
        'page': currentPage.value.toString(),
      };

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
          final newRecords = response.data?.records ?? [];
          searchResults.addAll(newRecords);
          totalResults.value = response.data?.total ?? 0;

          // Check if there are more pages
          final pageLimit = response.data?.pageLimit ?? 0;
          hasMorePages.value = (searchResults.length < totalResults.value) &&
              (pageLimit > 0 && newRecords.length >= pageLimit);
        } else {
          hasMorePages.value = false;
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
          final newRecords = response.data?.records ?? [];
          searchResults.addAll(newRecords);
          totalResults.value = response.data?.total ?? 0;

          // Check if there are more pages
          final pageLimit = response.data?.pageLimit ?? 0;
          hasMorePages.value = (searchResults.length < totalResults.value) &&
              (pageLimit > 0 && newRecords.length >= pageLimit);
        } else {
          hasMorePages.value = false;
          if (response.message != null) {
            constants.showSnackBar(response.message!, SnackBarStatus.ERROR);
          }
        }
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorLoadingMore(e.toString()), SnackBarStatus.ERROR);
      print('Error loading more: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<bool> toggleJobFavorite(Job job) async {
    if (job.hashcode == null) {
      constants.showSnackBar(
        'Job information not available',
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
          final index = searchResults.indexWhere((j) =>
          j.job!.hashcode == job.hashcode);
          if (index != -1) {
            searchResults[index].job!.isFavorite = false;
            searchResults.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            'Removed from favorites',
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to remove from favorites',
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
          final index = searchResults.indexWhere((j) =>
          j.job!.hashcode == job.hashcode);
          if (index != -1) {
            searchResults[index].job!.isFavorite = true;
            searchResults.refresh(); // Notify listeners
          }

          constants.showSnackBar(Resources
              .of(Get.context!)
              .strings
              .addedToFavorites, SnackBarStatus.SUCCESS);
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to add to favorites',
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
      print('Error toggling favorite: $e');
      return false;
    }
  }

  Future<bool> toggleMemberFavorite(User member) async {
    if (member.hashcode == null) {
      constants.showSnackBar(
        'Member information not available',
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
          // Update the member's favorite status in the employerResults list
          final index = searchResults.indexWhere(
                (data) => data.member?.hashcode == member.hashcode,
          );
          if (index != -1 && searchResults[index].member != null) {
            searchResults[index].member!.isFavorite = 0;
            searchResults.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            response.message ?? 'Removed from favorites',
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to remove from favorites',
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
          // Update the member's favorite status in the employerResults list
          final index = searchResults.indexWhere(
                (data) => data.member?.hashcode == member.hashcode,
          );
          if (index != -1 && searchResults[index].member != null) {
            searchResults[index].member!.isFavorite = 1;
            searchResults.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            response.message ?? 'Added to favorites',
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to add to favorites',
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
        'Service information not available',
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
          // Update the service's favorite status in the employerResults list
          final index = searchResults.indexWhere(
                (data) => data.service?.hashcode == service.hashcode,
          );
          if (index != -1 && searchResults[index].service != null) {
            searchResults[index].service!.isFavorite = false;
            searchResults.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            response.message ?? 'Removed from favorites',
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to remove from favorites',
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
          // Update the service's favorite status in the employerResults list
          final index = searchResults.indexWhere(
                (data) => data.service?.hashcode == service.hashcode,
          );
          if (index != -1 && searchResults[index].service != null) {
            searchResults[index].service!.isFavorite = true;
            searchResults.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            response.message ?? 'Added to favorites',
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to add to favorites',
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
          // Update the package's favorite status in the employerResults list
          final index = searchResults.indexWhere(
                (data) => data.package?.hashcode == package.hashcode,
          );
          if (index != -1 && searchResults[index].package != null) {
            searchResults[index].package!.isFavorite = false;
            searchResults.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            response.message ?? 'Removed from favorites',
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to remove from favorites',
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
          // Update the package's favorite status in the employerResults list
          final index = searchResults.indexWhere(
                (data) => data.package?.hashcode == package.hashcode,
          );
          if (index != -1 && searchResults[index].package != null) {
            searchResults[index].package!.isFavorite = true;
            searchResults.refresh(); // Notify listeners
          }

          constants.showSnackBar(
            response.message ?? 'Added to favorites',
            SnackBarStatus.SUCCESS,
          );
          return true;
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to add to favorites',
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
