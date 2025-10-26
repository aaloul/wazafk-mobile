import 'package:get/get.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_service_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_service_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class ServiceDetailsController extends GetxController {
  var service = Rxn<Service>();
  var isLoading = false.obs;
  var isFavorite = false.obs;
  var isFavoriteLoading = false.obs;

  final AddFavoriteServiceRepository _addFavoriteRepository =
  AddFavoriteServiceRepository();
  final RemoveFavoriteServiceRepository _removeFavoriteRepository =
  RemoveFavoriteServiceRepository();

  @override
  void onInit() {
    super.onInit();

    // Get service from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Service) {
      service.value = arguments;
      isFavorite.value = arguments.isFavorite ?? false;
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
          isFavorite.value = false;
          service.value!.isFavorite = false;
          constants.showSnackBar(
            response.message ?? 'Removed from favorites',
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
        final response = await _addFavoriteRepository.addFavoriteService(
          service.value!.hashcode ?? '',
        );

        if (response.success == true) {
          isFavorite.value = true;
          service.value!.isFavorite = true;
          constants.showSnackBar(
            response.message ?? 'Added to favorites',
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
        'Error: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isFavoriteLoading.value = false;
    }
  }
}
