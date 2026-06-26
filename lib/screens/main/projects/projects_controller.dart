import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/repository/favorite/favorites_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_job_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_service_repository.dart';

import '../../../model/FavoritesResponse.dart';
import '../../../utils/Prefs.dart';
import '../../../utils/res/Resources.dart';
import '../../../utils/utils.dart';
import '../home/home_controller.dart';

class ProjectsController extends GetxController {
  var selectedTab = ''.obs;

  // Repositories
  final _engagementsRepository = EngagementsListRepository();
  final _favoritesRepository = FavoritesRepository();
  final _removeFavoriteJobRepository = RemoveFavoriteJobRepository();
  final _removeFavoriteServiceRepository = RemoveFavoriteServiceRepository();
  final _removeFavoritePackageRepository = RemoveFavoritePackageRepository();

  // State variables
  var isLoadingEngagements = false.obs;
  var isLoadingFavorites = false.obs;
  var removingFavoriteHashcode = ''.obs;
  var ongoingEngagements = <Engagement>[].obs;
  var pendingEngagements = <Engagement>[].obs;
  var completedEngagements = <Engagement>[].obs;
  var disputedEngagements = <Engagement>[].obs;
  var favorites = <FavoriteData>[].obs;

  /// Local search over the currently shown engagement list.
  var searchQuery = ''.obs;

  /// Filters [list] locally by title / other-party name / description.
  List<Engagement> filterEngagements(List<Engagement> list) {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return list;
    String title(Engagement e) {
      switch (e.type) {
        case 'SB':
          return e.services?.first.title ?? '';
        case 'PB':
          return e.package?.title ?? '';
        default:
          return e.job?.title ?? '';
      }
    }

    return list.where((e) {
      final name =
          '${e.clientFirstName ?? ''} ${e.clientLastName ?? ''} ${e.freelancerFirstName ?? ''} ${e.freelancerLastName ?? ''}';
      return title(e).toLowerCase().contains(q) ||
          (e.description ?? '').toLowerCase().contains(q) ||
          name.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    selectedTab.value = Resources.of(Get.context!).strings.active;
    fetchOngoingEngagements();
    fetchPendingEngagements();
    fetchCompletedEngagements();
    fetchDisputedEngagements();
    fetchSavedItems();
  }

  Future<void> fetchOngoingEngagements({bool? isLoading}) async {
    try {
      isLoadingEngagements.value = isLoading ?? true;
      final response = await _engagementsRepository.getEngagements(
        filters: {
          'freelancer': Prefs.getId,
          'flow': 'ONGOING',
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

  Future<void> fetchPendingEngagements({bool? isLoading}) async {
    try {
      isLoadingEngagements.value = isLoading ?? true;
      final response = await _engagementsRepository.getEngagements(
        filters: {
          'flow': 'PENDING',
          'freelancer': Prefs.getId,
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

  Future<void> fetchCompletedEngagements({bool? isLoading}) async {
    try {
      isLoadingEngagements.value = isLoading ?? true;
      final response = await _engagementsRepository.getEngagements(
        filters: {
          'flow': 'CLOSED',
          'freelancer': Prefs.getId,
        },
      );
      if (response.success == true && response.data?.list != null) {
        completedEngagements.value = response.data!.list!;
      }
    } catch (e) {
      print('Error fetching completed engagements: $e');
    } finally {
      isLoadingEngagements.value = false;
    }
  }

  Future<void> fetchDisputedEngagements({bool? isLoading}) async {
    try {
      isLoadingEngagements.value = isLoading ?? true;
      final response = await _engagementsRepository.getEngagements(
        filters: {
          'flow': 'ON_HOLD',
          'freelancer': Prefs.getId,
        },
      );
      if (response.success == true && response.data?.list != null) {
        disputedEngagements.value = response.data!.list!;
      }
    } catch (e) {
      print('Error fetching disputed engagements: $e');
    } finally {
      isLoadingEngagements.value = false;
    }
  }

  /// Saved tab — favorited jobs, services and packages.
  Future<void> fetchSavedItems({bool? isLoading}) async {
    try {
      isLoadingFavorites.value = isLoading ?? true;
      final response = await _favoritesRepository.getFavorites(type: 'J,S,P');
      favorites.value = response.data ?? [];
    } catch (e) {
      print('Error fetching saved items: $e');
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  void refreshCurrentTab() {
    final strings = Resources.of(Get.context!).strings;
    switch (selectedTab.value) {
      case var tab when tab == strings.active:
        fetchOngoingEngagements();
        break;
      case var tab when tab == strings.pending:
        fetchPendingEngagements();
        break;
      case var tab when tab == strings.completed:
        fetchCompletedEngagements();
        break;
      case var tab when tab == strings.dispute:
        fetchDisputedEngagements();
        break;
      case var tab when tab == strings.saved:
        fetchSavedItems();
        break;
    }
  }

  Future<void> toggleJobFavorite(String jobHashcode) async {
    try {
      removingFavoriteHashcode.value = jobHashcode;

      final response = await _removeFavoriteJobRepository.removeFavoriteJob(
        jobHashcode,
      );

      if (response.success == true) {
        // Remove the job from the favorites list
        favorites.removeWhere(
              (favorite) => favorite.job?.hashcode == jobHashcode,
        );

        final controller = Get.find<HomeController>();
        controller.refreshHomeData();

        // Show success message
        constants.showSnackBar(Resources
            .of(Get.context!)
            .strings
            .removedFromFavorites,
          SnackBarStatus.SUCCESS,
        );
      } else {
        constants.showSnackBar(response.message ??
              Resources.of(Get.context!).strings.failedToRemoveFavorite,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error toggling job favorite: $e');
      constants.showSnackBar(
        Resources.of(Get.context!).strings.failedToRemoveFavorite,
        SnackBarStatus.ERROR,
      );
    } finally {
      removingFavoriteHashcode.value = '';
    }
  }

  Future<bool> toggleServiceFavorite(Service service) async {
    if (service.hashcode == null) return false;
    try {
      final response = await _removeFavoriteServiceRepository
          .removeFavoriteService(service.hashcode!);
      if (response.success == true) {
        favorites
            .removeWhere((f) => f.service?.hashcode == service.hashcode);
        constants.showSnackBar(
          Resources.of(Get.context!).strings.removedFromFavorites,
          SnackBarStatus.SUCCESS,
        );
        return true;
      }
      constants.showSnackBar(
        response.message ??
            Resources.of(Get.context!).strings.failedToRemoveFavorite,
        SnackBarStatus.ERROR,
      );
      return false;
    } catch (e) {
      print('Error removing favorite service: $e');
      return false;
    }
  }

  Future<bool> togglePackageFavorite(Package package) async {
    if (package.hashcode == null) return false;
    try {
      final response = await _removeFavoritePackageRepository
          .removeFavoritePackage(package.hashcode!);
      if (response.success == true) {
        favorites
            .removeWhere((f) => f.package?.hashcode == package.hashcode);
        constants.showSnackBar(
          Resources.of(Get.context!).strings.removedFromFavorites,
          SnackBarStatus.SUCCESS,
        );
        return true;
      }
      constants.showSnackBar(
        response.message ??
            Resources.of(Get.context!).strings.failedToRemoveFavorite,
        SnackBarStatus.ERROR,
      );
      return false;
    } catch (e) {
      print('Error removing favorite package: $e');
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
