import 'package:get/get.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/repository/package/package_status_repository.dart';
import 'package:wazafak_app/repository/package/packages_list_repository.dart';
import 'package:wazafak_app/repository/service/services_list_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../components/sheets/success_sheet.dart';
import '../../../../utils/Prefs.dart';
import '../../../../utils/res/AppIcons.dart';
import '../../../../utils/res/Resources.dart';

class PacksController extends GetxController {
  final _repository = PackagesListRepository();
  final _statusRepository = PackageStatusRepository();
  final _servicesRepository = ServicesListRepository();

  var isLoading = false.obs;
  var packages = <Package>[].obs;
  var isUpdatingStatus = false.obs;

  /// Whether the member has any service. A work package hangs off a service,
  /// so creating one is blocked until there is at least one. `null` means the
  /// check hasn't answered yet (or failed) — those cases don't block.
  var hasServices = Rxn<bool>();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;

  }

  /// Packages require a service; look one up alongside the list.
  Future<void> checkServices() async {
    try {
      final response = await _servicesRepository.getServices(
        filters: {'member': Prefs.getId},
      );
      if (response.success == true) {
        hasServices.value = (response.data?.list ?? []).isNotEmpty;
      }
    } catch (e) {
      // Leave it unknown so the user isn't blocked by a failed lookup.
      print('Error checking services: $e');
    }
  }

  /// False only when we know for sure there is no service to attach a pack to.
  bool get canCreatePackage => hasServices.value != false;

  Future<void> fetchPackages() async {
    isLoading.value = true;

    try {
      Map<String, String>? filters = {};
      filters['member'] = Prefs.getId;

      final response = await _repository.getPackages(filters: filters);

      if (response.success == true && response.data?.list != null) {
        packages.value = response.data!.list!;
        // Initialize checked state based on status
        for (var package in packages) {
          package.checked.value = package.status == 1;
        }
      } else {
        constants.showSnackBar(
          response.message ?? Resources.of(Get.context!).strings.failedToLoadPackages,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorLoadingPackages(e.toString()),
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

        final strings = Resources.of(Get.context!).strings;
        SuccessSheet.show(
          Get.context!,
          title: package.checked.value ? strings.packagePosted : strings.packageDisabled,
          image: package.checked.value
              ? AppIcons.servicePosted
              : AppIcons.serviceRemoved,
          description: package.checked.value
              ? strings.packageNowLiveDescription
              : strings.packageDisabledDescription,
          buttonText: strings.close,
        );
      } else {
        constants.showSnackBar(
          response.message ?? Resources.of(Get.context!).strings.failedToUpdatePackageStatus,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorUpdatingPackageStatus(e.toString()),
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
