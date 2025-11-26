import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/FavoritesResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_service_repository.dart';
import 'package:wazafak_app/repository/favorite/favorites_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_service_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../home/home_controller.dart';

class ActivitiesController extends GetxController {
  var selectedTab = 'Project & Services'.obs;

  // Repositories
  final _engagementsRepository = EngagementsListRepository();
  final _favoritesRepository = FavoritesRepository();
  final _addFavoriteServiceRepository = AddFavoriteServiceRepository();
  final _removeFavoriteServiceRepository = RemoveFavoriteServiceRepository();
  final _addFavoritePackageRepository = AddFavoritePackageRepository();
  final _removeFavoritePackageRepository = RemoveFavoritePackageRepository();
  final _favoriteMembersRepository = FavoritesRepository();

  // State variables
  var isLoadingEngagements = false.obs;
  var isLoadingFavorites = false.obs;
  var ongoingEngagements = <Engagement>[].obs;
  var pendingEngagements = <Engagement>[].obs;
  var favorites = <FavoriteData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOngoingEngagements();
    fetchPendingEngagements();
    fetchFavoriteJobs();
  }

  Future<void> fetchOngoingEngagements() async {
    try {
      isLoadingEngagements.value = true;
      final response = await _engagementsRepository.getEngagements(
        filters: {
          'flow': 'ONGOING',
          'client': Prefs.getId,
        }, // Assuming status 1 is for ongoing
      );
      if (response.success == true && response.data?.list != null) {
        ongoingEngagements.value = response.data!.list!;
      }
    } catch (e) {
      print('Error fetching ongoing engagements: $e');
    } finally {
      isLoadingEngagements.value = false;
    }
  }

  Future<void> fetchPendingEngagements() async {
    try {
      isLoadingEngagements.value = true;
      final response = await _engagementsRepository.getEngagements(
        filters: {
          'flow': 'PENDING',
          'client': Prefs.getId,
        }, // Assuming status 0 is for pending
      );
      if (response.success == true && response.data?.list != null) {
        pendingEngagements.value = response.data!.list!;
      }
    } catch (e) {
      print('Error fetching pending engagements: $e');
    } finally {
      isLoadingEngagements.value = false;
    }
  }

  Future<void> fetchFavoriteJobs() async {
    try {
      isLoadingFavorites.value = true;
      final response = await _favoritesRepository.getFavorites(type: 'M,S,P');
      favorites.value = response.data ?? [];
    } catch (e) {
      print('Error fetching favorite jobs: $e');
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  void refreshCurrentTab() {
    switch (selectedTab.value) {
      case 'Project & Services':
        fetchOngoingEngagements();
        break;
      case 'Pending':
        fetchPendingEngagements();
        break;
      case 'Pins':
        fetchFavoriteJobs();
        break;
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
          // Remove from favorites list
          favorites.removeWhere(
                (data) => data.member?.hashcode == member.hashcode,
          );
          favorites.refresh();

          final controller = Get.find<HomeController>();
          controller.refreshHomeData();

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
          // Update the member's favorite status in the list
          final index = favorites.indexWhere(
                (data) => data.member?.hashcode == member.hashcode,
          );
          if (index != -1 && favorites[index].member != null) {
            favorites[index].member!.isFavorite = 1;
            favorites.refresh();
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
            .removeFavoriteService(
          service.hashcode!,
        );

        if (response.success == true) {
          // Remove from favorites list
          favorites.removeWhere(
                (data) => data.service?.hashcode == service.hashcode,
          );
          favorites.refresh();

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
          // Update the service's favorite status in the list
          final index = favorites.indexWhere(
                (data) => data.service?.hashcode == service.hashcode,
          );
          if (index != -1 && favorites[index].service != null) {
            favorites[index].service!.isFavorite = true;
            favorites.refresh();
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
            .removeFavoritePackage(
          package.hashcode!,
        );

        if (response.success == true) {
          // Remove from favorites list
          favorites.removeWhere(
                (data) => data.package?.hashcode == package.hashcode,
          );
          favorites.refresh();

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
          // Update the package's favorite status in the list
          final index = favorites.indexWhere(
                (data) => data.package?.hashcode == package.hashcode,
          );
          if (index != -1 && favorites[index].package != null) {
            favorites[index].package!.isFavorite = true;
            favorites.refresh();
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
    super.onClose();
  }
}
