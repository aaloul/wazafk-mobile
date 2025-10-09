import 'package:get/get.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/repository/package/package_status_repository.dart';
import 'package:wazafak_app/repository/package/packages_list_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class PacksController extends GetxController {
  final _repository = PackagesListRepository();
  final _statusRepository = PackageStatusRepository();

  var isLoading = false.obs;
  var packages = <Package>[].obs;
  var isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
  }

  Future<void> fetchPackages() async {
    try {
      Map<String, String>? filters = {};
      // filters['member'] = Prefs.getId;

      final response = await _repository.getPackages(filters: filters);

      if (response.success == true && response.data?.list != null) {
        packages.value = response.data!.list!;
        // Initialize checked state based on status
        for (var package in packages) {
          package.checked.value = package.status == 1;
        }
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load packages',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error loading packages: $e',
        SnackBarStatus.ERROR,
      );
      print('Error loading packages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePackageStatus(Package package) async {
    if (isUpdatingStatus.value) return;

    try {
      isUpdatingStatus.value = true;

      // Toggle status: 1 = active, 0 = inactive
      final newStatus = package.status == 1 ? 0 : 1;

      final response = await _statusRepository.updatePackageStatus(
        package.hashcode!,
        newStatus,
      );

      if (response.success == true) {
        // Update local package status
        package.status = newStatus;
        package.checked.value = newStatus == 1;
        packages.refresh();

        constants.showSnackBar(
          response.message ?? 'Package status updated successfully',
          SnackBarStatus.SUCCESS,
        );
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to update package status',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating package status: $e',
        SnackBarStatus.ERROR,
      );
      print('Error updating package status: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
