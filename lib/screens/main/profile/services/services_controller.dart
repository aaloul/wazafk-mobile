import 'package:get/get.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/service/service_status_repository.dart';
import 'package:wazafak_app/repository/service/services_list_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../utils/Prefs.dart';

class ServicesController extends GetxController {
  final _repository = ServicesListRepository();
  final _statusRepository = ServiceStatusRepository();

  var isLoading = false.obs;
  var services = <Service>[].obs;
  var isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
  }

  Future<void> fetchServices() async {
    try {

      Map<String, String>? filters = {};
      filters['member'] = Prefs.getId;

      final response = await _repository.getServices(filters: filters);

      if (response.success == true && response.data?.list != null) {
        services.value = response.data!.list!;
        // Initialize checked state based on status
        for (var service in services) {
          service.checked.value = service.status == 1;
        }
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load services',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error loading services: $e',
        SnackBarStatus.ERROR,
      );
      print('Error loading services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleServiceStatus(Service service) async {
    if (isUpdatingStatus.value) return;

    try {
      isUpdatingStatus.value = true;

      // Toggle status: 1 = active, 0 = inactive
      final newStatus = service.status == 1 ? 0 : 1;

      final response = await _statusRepository.updateServiceStatus(
        service.hashcode!,
        newStatus,
      );

      if (response.success == true) {
        // Update local service status
        service.status = newStatus;
        service.checked.value = newStatus == 1;
        services.refresh();

        constants.showSnackBar(
          response.message ?? 'Service status updated successfully',
          SnackBarStatus.SUCCESS,
        );
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to update service status',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating service status: $e',
        SnackBarStatus.ERROR,
      );
      print('Error updating service status: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
