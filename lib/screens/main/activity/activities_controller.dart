import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/FavoritesResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/repository/favorite/favorite_jobs_repository.dart';

import '../../../repository/favorite/favorites_repository.dart';

class ActivitiesController extends GetxController {
  var selectedTab = 'Project & Services'.obs;

  // Repositories
  final _engagementsRepository = EngagementsListRepository();
  final _favoritesRepository = FavoritesRepository();

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
          // 'type': 'JA',
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

  Future<void> fetchPendingEngagements() async {
    try {
      isLoadingEngagements.value = true;
      final response = await _engagementsRepository.getEngagements(
        filters: {
          'flow': 'PENDING',
          // 'type': 'JA',
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

  @override
  void onClose() {
    super.onClose();
  }
}
