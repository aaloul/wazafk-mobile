import 'package:get/get.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_job_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_job_repository.dart';
import 'package:wazafak_app/repository/job/job_status_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class JobDetailsController extends GetxController {
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

    // Get job from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Job) {
      job.value = arguments;
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
        // Update local job status
        job.value!.status = 0;
        job.refresh();

        constants.showSnackBar(
          response.message ?? 'Job disabled successfully',
          SnackBarStatus.SUCCESS,
        );

        // Go back after successful disable
        Get.back();
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to disable job',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error disabling job: $e', SnackBarStatus.ERROR);
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
          job.value!.isFavorite = false;
          job.refresh();
          constants.showSnackBar(
            'Removed from favorites',
            SnackBarStatus.SUCCESS,
          );
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
          job.value!.isFavorite = true;
          job.refresh();
          constants.showSnackBar(
            'Added to favorites',
            SnackBarStatus.SUCCESS,
          );
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
