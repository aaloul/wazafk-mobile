import 'package:get/get.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_job_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_job_repository.dart';
import 'package:wazafak_app/repository/job/job_detail_repository.dart';
import 'package:wazafak_app/repository/job/job_status_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class JobDetailsController extends GetxController {
  final JobDetailRepository _jobDetailRepository = JobDetailRepository();
  final JobStatusRepository _jobStatusRepository = JobStatusRepository();
  final AddFavoriteJobRepository _addFavoriteJobRepository = AddFavoriteJobRepository();
  final RemoveFavoriteJobRepository _removeFavoriteJobRepository = RemoveFavoriteJobRepository();

  var job = Rxn<Job>();
  var isLoading = false.obs;
  var isUpdatingStatus = false.obs;
  var isTogglingFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    isLoading.value = true;

    // Handle both Job object and String hashcode
    if (arguments != null && arguments is Job) {
      job.value = arguments;

      // Fetch fresh details from API if hashcode is available
      if (arguments.hashcode != null) {
        getJobDetails(arguments.hashcode!);
      } else {
        isLoading.value = false;
      }
    } else if (arguments != null && arguments is String) {
      // Hashcode passed directly
      getJobDetails(arguments);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> getJobDetails(String hashcode) async {
    try {
      final response = await _jobDetailRepository.getJob(hashcode);

      if (response.success == true && response.data != null) {
        // Parse the job from response

        final Job? jobData = response.data?.list?.first;

        if (jobData != null) {
          job.value = jobData;
        } else {
          constants.showSnackBar(
            'Job details not found',
            SnackBarStatus.ERROR,
          );
        }
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load job details',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error fetching job details: $e');
      constants.showSnackBar(
        'Error loading job details',
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshJobDetails() async {
    if (job.value?.hashcode != null) {
      await getJobDetails(job.value!.hashcode!);
    }
  }

  Future<void> disableJob() async {
    if (job.value == null || job.value!.hashcode == null) {
      constants.showSnackBar(
        'Job information not available',
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isUpdatingStatus.value = true;

      // Status 0 typically means disabled/inactive
      final response = await _jobStatusRepository.updateJobStatus(
        job.value!.hashcode!,
        0,
      );

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Job disabled successfully',
          SnackBarStatus.SUCCESS,
        );

        // Refresh job details to get updated status
        await refreshJobDetails();

        // Go back after successful disable
        Get.back();
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to disable job',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .errorDisablingJob(e.toString()), SnackBarStatus.ERROR);
      print('Error disabling job: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    if (job.value == null || job.value!.hashcode == null) {
      constants.showSnackBar(
        'Job information not available',
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isTogglingFavorite.value = true;

      final isFavorite = job.value!.isFavorite ?? false;

      if (isFavorite) {
        // Remove from favorites
        final response = await _removeFavoriteJobRepository.removeFavoriteJob(
          job.value!.hashcode!,
        );

        if (response.success == true) {
          constants.showSnackBar(
            'Removed from favorites',
            SnackBarStatus.SUCCESS,
          );
          // Refresh job details to get updated favorite status
          await refreshJobDetails();
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to remove from favorites',
            SnackBarStatus.ERROR,
          );
        }
      } else {
        // Add to favorites
        final response = await _addFavoriteJobRepository.addFavoriteJob(
          job.value!.hashcode!,
        );

        if (response.success == true) {
          constants.showSnackBar(
            'Added to favorites',
            SnackBarStatus.SUCCESS,
          );
          // Refresh job details to get updated favorite status
          await refreshJobDetails();
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to add to favorites',
            SnackBarStatus.ERROR,
          );
        }
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating favorites: $e',
        SnackBarStatus.ERROR,
      );
      print('Error toggling favorite: $e');
    } finally {
      isTogglingFavorite.value = false;
    }
  }
}
