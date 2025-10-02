import 'package:get/get.dart';
import 'package:wazafak_app/repository/app/about_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class AboutUsController extends GetxController {
  final _repository = AboutRepository();

  var isLoading = true.obs;
  var htmlContent = ''.obs;
  var title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    try {
      isLoading.value = true;

      final response = await _repository.getAboutUs();

      if (response.success == true && response.data != null) {
        htmlContent.value = response.data!.content ?? '';
        title.value = response.data!.title ?? 'About Us';
      } else {
        constants.showSnackBar(
            response.message ?? 'Failed to load about us',
            SnackBarStatus.ERROR);
      }
    } catch (e) {
      constants.showSnackBar(
          'Error loading about us: $e', SnackBarStatus.ERROR);
      print('Error loading about us: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
