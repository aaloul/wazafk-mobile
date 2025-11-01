import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/repository/favorite/favorite_jobs_repository.dart';

import '../../../model/FavoritesResponse.dart';
import '../../../utils/Prefs.dart';

class ProjectsController extends GetxController {
  var selectedTab = 'Ongoing Project'.obs;

  // Repositories
  final _engagementsRepository = EngagementsListRepository();
  final _favoriteJobsRepository = FavoriteJobsRepository();

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
          'freelancer': Prefs.getId,
          'flow': 'ONGOING'
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

  Future<void> fetchFavoriteJobs() async {
    try {
      isLoadingFavorites.value = true;
      final response = await _favoriteJobsRepository.getFavoriteJobs();
      favorites.value = response.data ?? [];
    } catch (e) {
      print('Error fetching favorite jobs: $e');
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  void refreshCurrentTab() {
    switch (selectedTab.value) {
      case 'Ongoing Project':
        fetchOngoingEngagements();
        break;
      case 'Pending':
        fetchPendingEngagements();
        break;
      case 'Saved Jobs':
        fetchFavoriteJobs();
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
