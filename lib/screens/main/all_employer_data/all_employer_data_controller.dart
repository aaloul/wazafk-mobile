import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/EmployerHomeResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_service_repository.dart';
import 'package:wazafak_app/repository/favorite/favorites_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_service_repository.dart';
import 'package:wazafak_app/repository/home/employer_home_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

class AllEmployerDataController extends GetxController {
  final EmployerHomeRepository _repository = EmployerHomeRepository();
  final _favoriteMembersRepository = FavoritesRepository();
  final _addFavoriteServiceRepository = AddFavoriteServiceRepository();
  final _removeFavoriteServiceRepository = RemoveFavoriteServiceRepository();
  final _addFavoritePackageRepository = AddFavoritePackageRepository();
  final _removeFavoritePackageRepository = RemoveFavoritePackageRepository();

  // Tabs
  List<String> get tabs =>
      [
        Resources
            .of(Get.context!)
            .strings
            .all,
        Resources
            .of(Get.context!)
            .strings
            .freelancers,
        Resources
            .of(Get.context!)
            .strings
            .services,
        Resources
            .of(Get.context!)
            .strings
            .packages
      ];
  var selectedTab = "".obs;

  // Data
  var employerData = <EmployerHomeData>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

  // Pagination
  var currentPage = 1.obs;
  var pageLimit = 3.obs;
  var total = 0.obs;
  var pageIndices = ''.obs;
  var prevIndices = ''.obs;

  // ScrollController for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    selectedTab.value = Resources
        .of(Get.context!)
        .strings
        .all;
    _setupScrollListener();
    loadEmployerData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.8) {
        if (!isLoadingMore.value && hasMoreData.value) {
          loadMoreEmployerData();
        }
      }
    });
  }

  void changeTab(String tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;
      resetAndLoadData();
    }
  }

  void resetAndLoadData() {
    employerData.clear();
    currentPage.value = 1;
    pageIndices.value = '';
    prevIndices.value = '';
    hasMoreData.value = true;
    loadEmployerData();
  }

  String? _getEntityTypeFilter() {
    switch (selectedTab.value) {
      case String tab when tab == Resources
          .of(Get.context!)
          .strings
          .freelancers:
        return "MEMBER";
      case String tab when tab == Resources
          .of(Get.context!)
          .strings
          .services:
        return "SERVICE";
      case String tab when tab == Resources
          .of(Get.context!)
          .strings
          .packages:
        return "PACKAGE";
      default:
        return null; // "All" - no filter
    }
  }

  Future<void> loadEmployerData() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      Map<String, String> filters = {
        'page': currentPage.value.toString(),
        'page_limit': pageLimit.value.toString(),
      };

      // Add entity type filter if not "All"
      final entityType = _getEntityTypeFilter();
      if (entityType != null) {
        filters['entity_type'] = entityType;
      }

      // Add page indices if available (for cursor-based pagination)
      if (pageIndices.value.isNotEmpty) {
        filters['page_indices'] = pageIndices.value;
      }

      final response = await _repository.getEmployerHome(filters: filters);

      if (response.success == true && response.data != null) {
        employerData.value = response.data!.records ?? [];

        // Update pagination info
        currentPage.value = response.data!.page ?? 1;
        pageLimit.value = response.data!.pageLimit ?? 20;
        total.value = response.data!.total ?? 0;
        pageIndices.value = response.data!.pageIndices ?? '';
        prevIndices.value = response.data!.prevIndices ?? '';

        // Check if there's more data
        hasMoreData.value = employerData.length < total.value;
      }
    } catch (e) {
      print('Error loading employer data: $e');
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorLoadingData(e.toString()), SnackBarStatus.ERROR);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreEmployerData() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;

      int nextPage = currentPage.value + 1;

      Map<String, String> filters = {
        'page': nextPage.toString(),
        'page_limit': pageLimit.value.toString(),
      };

      // Add entity type filter if not "All"
      final entityType = _getEntityTypeFilter();
      if (entityType != null) {
        filters['entity_type'] = entityType;
      }

      // Add page indices for cursor-based pagination
      if (pageIndices.value.isNotEmpty) {
        filters['page_indices'] = pageIndices.value;
      }

      final response = await _repository.getEmployerHome(filters: filters);

      if (response.success == true && response.data != null) {
        List<EmployerHomeData> newData = response.data!.records ?? [];
        employerData.addAll(newData);

        // Update pagination info
        currentPage.value = response.data!.page ?? currentPage.value;
        pageIndices.value = response.data!.pageIndices ?? '';
        prevIndices.value = response.data!.prevIndices ?? '';

        // Check if there's more data
        hasMoreData.value = employerData.length < total.value;
      }
    } catch (e) {
      print('Error loading more employer data: $e');
      constants.showSnackBar(
        'Error loading more data: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshData() async {
    employerData.clear();
    currentPage.value = 1;
    pageIndices.value = '';
    prevIndices.value = '';
    hasMoreData.value = true;
    await loadEmployerData();
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
        final response = await _favoriteMembersRepository.removeFavoriteMember(
          member.hashcode!,
        );

        if (response.success == true) {
          final index = employerData.indexWhere(
            (data) => data.member?.hashcode == member.hashcode,
          );
          if (index != -1 && employerData[index].member != null) {
            employerData[index].member!.isFavorite = 0;
            employerData.refresh();
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
        final response = await _favoriteMembersRepository.addFavoriteMember(
          member.hashcode!,
        );

        if (response.success == true) {
          final index = employerData.indexWhere(
            (data) => data.member?.hashcode == member.hashcode,
          );
          if (index != -1 && employerData[index].member != null) {
            employerData[index].member!.isFavorite = 1;
            employerData.refresh();
          }

          constants.showSnackBar(Resources
              .of(Get.context!)
              .strings
              .addedToFavorites, SnackBarStatus.SUCCESS);
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
        Resources
            .of(Get.context!)
            .strings
            .errorUpdatingFavorites(e.toString()),
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
        final response = await _removeFavoriteServiceRepository
            .removeFavoriteService(service.hashcode!);

        if (response.success == true) {
          final index = employerData.indexWhere(
            (data) => data.service?.hashcode == service.hashcode,
          );
          if (index != -1 && employerData[index].service != null) {
            employerData[index].service!.isFavorite = false;
            employerData.refresh();
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
        final response = await _addFavoriteServiceRepository.addFavoriteService(
          service.hashcode!,
        );

        if (response.success == true) {
          final index = employerData.indexWhere(
            (data) => data.service?.hashcode == service.hashcode,
          );
          if (index != -1 && employerData[index].service != null) {
            employerData[index].service!.isFavorite = true;
            employerData.refresh();
          }

          constants.showSnackBar(Resources
              .of(Get.context!)
              .strings
              .addedToFavorites, SnackBarStatus.SUCCESS);
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
        Resources
            .of(Get.context!)
            .strings
            .errorUpdatingFavorites(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error toggling service favorite: $e');
      return false;
    }
  }

  Future<bool> togglePackageFavorite(Package package) async {
    if (package.hashcode == null) {
      constants.showSnackBar(
        Resources
            .of(Get.context!)
            .strings
            .packageInformationNotAvailable,
        SnackBarStatus.ERROR,
      );
      return false;
    }

    try {
      final isFavorite = package.isFavorite ?? false;

      if (isFavorite) {
        final response = await _removeFavoritePackageRepository
            .removeFavoritePackage(package.hashcode!);

        if (response.success == true) {
          final index = employerData.indexWhere(
            (data) => data.package?.hashcode == package.hashcode,
          );
          if (index != -1 && employerData[index].package != null) {
            employerData[index].package!.isFavorite = false;
            employerData.refresh();
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
        final response = await _addFavoritePackageRepository.addFavoritePackage(
          package.hashcode!,
        );

        if (response.success == true) {
          final index = employerData.indexWhere(
            (data) => data.package?.hashcode == package.hashcode,
          );
          if (index != -1 && employerData[index].package != null) {
            employerData[index].package!.isFavorite = true;
            employerData.refresh();
          }

          constants.showSnackBar(Resources
              .of(Get.context!)
              .strings
              .addedToFavorites, SnackBarStatus.SUCCESS);
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
        Resources
            .of(Get.context!)
            .strings
            .errorUpdatingFavorites(e.toString()),
        SnackBarStatus.ERROR,
      );
      print('Error toggling package favorite: $e');
      return false;
    }
  }
}
