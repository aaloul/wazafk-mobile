import 'package:get/get.dart';
import 'package:wazafak_app/model/JobApplicantsResponse.dart';
import 'package:wazafak_app/repository/job/job_applicants_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class JobApplicantsController extends GetxController {
  final JobApplicantsRepository _jobApplicantsRepository =
      JobApplicantsRepository();

  var applicants = <JobApplicant>[].obs;
  var isLoading = false.obs;
  String? jobHashcode;

  @override
  void onInit() {
    super.onInit();

    // Get job hashcode from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is String) {
      jobHashcode = arguments;
      fetchApplicants();
    }
  }

  Future<void> fetchApplicants() async {
    if (jobHashcode == null) {
      constants.showSnackBar(
        'Job information not available',
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Filter by job hashcode to get applicants for this specific job
      Map<String, String> filters = {'job': jobHashcode!};

      final response = await _jobApplicantsRepository.getJobApplicants(
        filters: filters,
      );

      if (response.success == true && response.data != null) {
        applicants.value = response.data!;
      } else {
        applicants.clear();
        if (response.message != null) {
          constants.showSnackBar(response.message!, SnackBarStatus.ERROR);
        }
      }
    } catch (e) {
      constants.showSnackBar(
        'Error fetching applicants: $e',
        SnackBarStatus.ERROR,
      );
      print('Error fetching applicants: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshApplicants() async {
    await fetchApplicants();
  }
}
