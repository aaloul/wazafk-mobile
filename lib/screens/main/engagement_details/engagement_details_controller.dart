import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/engagement/engagement_detail_repository.dart';

class EngagementDetailsController extends GetxController {
  final _repository = EngagementDetailRepository();

  final Rx<Engagement?> engagement = Rx<Engagement?>(null);
  final Rx<Service?> service = Rx<Service?>(null);
  final Rx<Package?> package = Rx<Package?>(null);
  final Rx<Job?> job = Rx<Job?>(null);
  final RxBool isPackage = false.obs;
  final RxBool isJob = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;

    if (arg is Engagement) {
      engagement.value = arg;

      // Set service, package, or job based on engagement type
      if (arg.type.toString() == 'SB' &&
          arg.services != null &&
          arg.services!.isNotEmpty) {
        service.value = arg.services!.first;
        isPackage.value = false;
        isJob.value = false;
      } else if (arg.type.toString() == 'PB' && arg.package != null) {
        package.value = arg.package;
        isPackage.value = true;
        isJob.value = false;
      } else if (arg.type.toString() == 'JA' && arg.job != null) {
        job.value = arg.job;
        isPackage.value = false;
        isJob.value = true;
      }

      // if (arg.hashcode != null) {
      //   fetchEngagementDetails(arg.hashcode!);
      // }
    } else if (arg is String) {
      // fetchEngagementDetails(arg);
    }
  }

  // Future<void> fetchEngagementDetails(String hashcode) async {
  //   isLoading.value = true;
  //   try {
  //     final response = await _repository.getEngagement(hashcode);
  //     if (response.success == true && response.data != null) {
  //       engagement.value = Engagement.fromJson(response.data);
  //     } else {
  //      showToast(response.message ?? 'Failed to load engagement details');
  //     }
  //   } catch (e) {
  //     Widgets.showToast('Error loading engagement details');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
