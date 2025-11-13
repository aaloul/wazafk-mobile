import 'package:get/get.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/networking/services/favorite/add_favorite_job_service.dart';
import 'package:wazafak_app/networking/services/favorite/remove_favorite_job_service.dart';
import 'package:wazafak_app/networking/services/job/jobs_list_service.dart';

class AllJobsController extends GetxController {
  final JobsListService _service = JobsListService();
  final AddFavoriteJobService _addFavoriteService = AddFavoriteJobService();
  final RemoveFavoriteJobService _removeFavoriteService =
      RemoveFavoriteJobService();

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var jobs = <Job>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs(isInitialLoad: true);
  }

  Future<void> fetchJobs({
    bool refresh = false,
    bool isInitialLoad = false,
  }) async {
    if (refresh) {
      currentPage.value = 1;
      jobs.clear();
      hasMore.value = true;
    }

    if (isLoading.value || isLoadingMore.value) return;

    if (refresh || isInitialLoad) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _service.getJobs(
        filters: {'page': currentPage.value.toString()},
      );

      if (response.success == true && response.data != null) {
        if (refresh) {
          jobs.value = response.data!.list ?? [];
        } else {
          jobs.addAll(response.data!.list ?? []);
        }

        if (response.data!.meta != null) {
          lastPage.value = response.data!.meta!.last ?? 1;
          currentPage.value = response.data!.meta!.page ?? 1;
          hasMore.value = currentPage.value < lastPage.value;
        }
      }
    } catch (e) {
      print('Error fetching jobs: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    currentPage.value++;
    await fetchJobs();
  }

  Future<void> refresh() async {
    await fetchJobs(refresh: true);
  }

  Future<bool> toggleJobFavorite(Job job) async {
    try {
      if (job.isFavorite == true) {
        final response = await _removeFavoriteService.removeFavoriteJob(
          job.hashcode ?? '',
        );
        if (response.success == true) {
          job.isFavorite = false;
          jobs.refresh();
          return true;
        }
      } else {
        final response = await _addFavoriteService.addFavoriteJob(
          job.hashcode ?? '',
        );
        if (response.success == true) {
          job.isFavorite = true;
          jobs.refresh();
          return true;
        }
      }
    } catch (e) {
      print('Error toggling job favorite: $e');
    }
    return false;
  }
}
