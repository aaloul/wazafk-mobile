import 'package:get/get.dart';
import 'package:wazafak_app/repository/account/settings_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class LoginAlertsController extends GetxController {
  final SettingsRepository _settingsRepository = SettingsRepository();

  final RxBool pushEnabled = true.obs;
  final RxBool emailEnabled = true.obs;
  final RxBool isLoading = false.obs;

  Future<void> setPush(bool value) async {
    pushEnabled.value = value;
    await _post({'alert_login_notification': value ? 1 : 0});
  }

  Future<void> setEmail(bool value) async {
    emailEnabled.value = value;
    await _post({'alert_login_sms': value ? 1 : 0});
  }

  Future<void> _post(Map<String, int> prefs) async {
    try {
      isLoading.value = true;
      final response =
          await _settingsRepository.changeNotificationPreferences(prefs);
      if (response.success != true) {
        constants.showSnackBar(
          response.message ?? 'Failed to update login alerts',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating login alerts: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
