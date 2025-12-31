import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/repository/favorite/favorite_jobs_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_job_repository.dart';

import '../../../model/FavoritesResponse.dart';
import '../../../utils/Prefs.dart';
import '../../../utils/res/Resources.dart';
import '../../../utils/utils.dart';
import '../home/home_controller.dart';

class ProjectsController extends GetxController {
  var selectedTab = ''.obs;

  // Repositories
  final _engagementsRepository = EngagementsListRepository();
  final _favoriteJobsRepository = FavoriteJobsRepository();
  final _removeFavoriteJobRepository = RemoveFavoriteJobRepository();

  // State variables
  var isLoadingEngagements = false.obs;
  var isLoadingFavorites = false.obs;
  var removingFavoriteHashcode = ''.obs;
  var ongoingEngagements = <Engagement>[].obs;
  var pendingEngagements = <Engagement>[].obs;
  var completedEngagements = <Engagement>[].obs;
  var favorites = <FavoriteData>[].obs;

  @override
  void onInit() {
    super.onInit();
    selectedTab.value = Resources.of(Get.context!).strings.ongoingProject;
    fetchOngoingEngagements();
    fetchPendingEngagements();
    fetchCompletedEngagements();
    fetchFavoriteJobs();
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

  Future<void> fetchFavoriteJobs({bool? isLoading}) async {
    try {
      isLoadingFavorites.value = isLoading ?? true;
      final response = await _favoriteJobsRepository.getFavoriteJobs();
      favorites.value = response.data ?? [];
    } catch (e) {
      print('Error fetching favorite jobs: $e');
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  void refreshCurrentTab() {
    final strings = Resources.of(Get.context!).strings;
    switch (selectedTab.value) {
      case var tab when tab == strings.ongoingProject:
        fetchOngoingEngagements();
        break;
      case var tab when tab == strings.pending:
        fetchPendingEngagements();
        break;
      case var tab when tab == strings.closedPaused:
        fetchCompletedEngagements();
        break;
      case var tab when tab == strings.savedJobs:
        fetchFavoriteJobs();
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

  @override
  void onClose() {
    super.onClose();
  }
}
