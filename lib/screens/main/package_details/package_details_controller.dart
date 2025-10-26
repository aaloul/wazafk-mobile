import 'package:get/get.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_package_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_package_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class PackageDetailsController extends GetxController {
  var package = Rxn<Package>();
  var isLoading = false.obs;
  var isFavorite = false.obs;
  var isFavoriteLoading = false.obs;

  final AddFavoritePackageRepository _addFavoriteRepository =
  AddFavoritePackageRepository();
  final RemoveFavoritePackageRepository _removeFavoriteRepository =
  RemoveFavoritePackageRepository();

  @override
  void onInit() {
    super.onInit();

    // Get package from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Package) {
      package.value = arguments;
      isFavorite.value = arguments.isFavorite ?? false;
    }
  }

  Future<void> toggleFavorite() async {
    if (isFavoriteLoading.value || package.value == null) return;

    try {
      isFavoriteLoading.value = true;

      if (isFavorite.value) {
        // Remove from favorites
        final response = await _removeFavoriteRepository.removeFavoritePackage(
          package.value!.hashcode ?? '',
        );

        if (response.success == true) {
          isFavorite.value = false;
          package.value!.isFavorite = false;
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
        final response = await _addFavoriteRepository.addFavoritePackage(
          package.value!.hashcode ?? '',
        );

        if (response.success == true) {
          isFavorite.value = true;
          package.value!.isFavorite = true;
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
