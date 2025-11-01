import 'package:get/get.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/repository/job/job_status_repository.dart';
import 'package:wazafak_app/repository/job/jobs_list_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../../components/sheets/success_sheet.dart';
import '../../../../../utils/res/AppIcons.dart';

class MyJobsController extends GetxController {
  final _repository = JobsListRepository();
  final _statusRepository = JobStatusRepository();

  var isLoading = false.obs;
  var jobs = <Job>[].obs;
  var isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
  }

  Future<void> fetchJobs() async {
    try {
      Map<String, String>? filters = {};
      filters['member'] = Prefs.getId;

      final response = await _repository.getJobs(filters: filters);

      if (response.success == true && response.data?.list != null) {
        jobs.value = response.data!.list!;
        // Initialize checked state based on status
        for (var job in jobs) {
          job.checked.value = job.status == 1;
        }
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load jobs',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar('Error loading jobs: $e', SnackBarStatus.ERROR);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleJobStatus(Job job) async {
    if (isUpdatingStatus.value) return;

    try {
      isUpdatingStatus.value = true;

      // Toggle status: 1 = active, 0 = inactive
      final newStatus = job.status == 1 ? 0 : 1;

      final response = await _statusRepository.updateJobStatus(
        job.hashcode!,
        newStatus,
      );

      if (response.success == true) {
        // Update local job status
        job.status = newStatus;
        job.checked.value = newStatus == 1;
        jobs.refresh();

        SuccessSheet.show(
          Get.context!,
          title: job.checked.value ? 'Job Posted' : 'Job Disabled',
          image: job.checked.value
              ? AppIcons.servicePosted
              : AppIcons.serviceRemoved,
          description: job.checked.value
              ? 'Your Job is now live! Keep an eye out for opportunities.'
              : 'Your Job will be disable, you can activate it later .',
          buttonText: 'View Profile',
        );
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to update job status',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating job status: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}
