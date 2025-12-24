import 'package:get/get.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_service_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_service_repository.dart';
import 'package:wazafak_app/repository/service/service_detail_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../utils/res/Resources.dart';

class ServiceDetailsController extends GetxController {
  var service = Rxn<Service>();
  var isLoading = false.obs;
  var isFavorite = false.obs;
  var isFavoriteLoading = false.obs;

  final ServiceDetailRepository _serviceDetailRepository = ServiceDetailRepository();
  final AddFavoriteServiceRepository _addFavoriteRepository =
  AddFavoriteServiceRepository();
  final RemoveFavoriteServiceRepository _removeFavoriteRepository =
  RemoveFavoriteServiceRepository();

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    isLoading.value = true;

    // Handle both Service object and String hashcode
    if (arguments != null && arguments is Service) {
      service.value = arguments;
      isFavorite.value = arguments.isFavorite ?? false;

      // Fetch fresh details from API if hashcode is available
      if (arguments.hashcode != null) {
        getServiceDetails(arguments.hashcode!);
      } else {
        isLoading.value = false;
      }
    } else if (arguments != null && arguments is String) {
      // Hashcode passed directly
      getServiceDetails(arguments);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> getServiceDetails(String hashcode) async {
    try {
      final response = await _serviceDetailRepository.getService(hashcode);

      if (response.success == true && response.data != null) {
        // Parse the service from response
        final Service? serviceData = response.data?.list?.first;

        if (serviceData != null) {
          service.value = serviceData;
          isFavorite.value = serviceData.isFavorite ?? false;
        } else {
          constants.showSnackBar(
            'Service details not found',
            SnackBarStatus.ERROR,
          );
        }
      } else {
        constants.showSnackBar(
          response.message ?? Resources.of(Get.context!).strings.failedToLoadServiceDetails,
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      print('Error fetching service details: $e');
      constants.showSnackBar(
        Resources.of(Get.context!).strings.errorLoadingServiceDetails(e.toString()),
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshServiceDetails() async {
    if (service.value?.hashcode != null) {
      await getServiceDetails(service.value!.hashcode!);
    }
  }

  Future<void> toggleFavorite() async {
    if (isFavoriteLoading.value || service.value == null) return;

    try {
      isFavoriteLoading.value = true;

      if (isFavorite.value) {
        // Remove from favorites
        final response = await _removeFavoriteRepository.removeFavoriteService(
          service.value!.hashcode ?? '',
        );

        if (response.success == true) {
          constants.showSnackBar(
            response.message ?? 'Removed from favorites',
            SnackBarStatus.SUCCESS,
          );
          // Refresh service details to get updated favorite status
          await refreshServiceDetails();
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to remove from favorites',
            SnackBarStatus.ERROR,
          );
        }
      } else {
        // Add to favorites
        final response = await _addFavoriteRepository.addFavoriteService(
          service.value!.hashcode ?? '',
        );

        if (response.success == true) {
          constants.showSnackBar(
            response.message ?? 'Added to favorites',
            SnackBarStatus.SUCCESS,
          );
          // Refresh service details to get updated favorite status
          await refreshServiceDetails();
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to add to favorites',
            SnackBarStatus.ERROR,
          );
        }
      }
    } catch (e) {
      constants.showSnackBar(
        'Error: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isFavoriteLoading.value = false;
    }
  }
}
