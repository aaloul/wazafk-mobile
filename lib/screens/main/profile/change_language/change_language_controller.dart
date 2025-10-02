import 'dart:ui';

import 'package:get/get.dart';
import 'package:wazafak_app/repository/account/settings_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class ChangeLanguageController extends GetxController {
  final _repository = SettingsRepository();

  var selectedLanguage = 'en'.obs;
  var isLoading = false.obs;

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ar', 'name': 'العربية'},
  ];

  @override
  void onInit() {
    super.onInit();
    // Get current language from Get.locale or shared preferences
    selectedLanguage.value = Get.locale?.languageCode ?? 'en';
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      isLoading.value = true;
      selectedLanguage.value = languageCode;

      final response = await _repository.changeLanguage(languageCode);

      if (response.success == true) {
        // Update app locale
        Locale locale = Locale(languageCode);
        Get.updateLocale(locale);

        constants.showSnackBar(
            response.message ?? 'Language changed successfully',
            SnackBarStatus.SUCCESS);
      } else {
        constants.showSnackBar(
            response.message ?? 'Failed to change language',
            SnackBarStatus.ERROR);
      }
    } catch (e) {
      constants.showSnackBar(
          'Error changing language: $e', SnackBarStatus.ERROR);
      print('Error changing language: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
