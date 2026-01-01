import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../model/SettingsModel.dart';
import '../../../../repository/account/settings_repository.dart';

class NotificationSettingsController extends GetxController {
  final SettingsRepository _settingsRepository = SettingsRepository();

  // Mapping from setting ID to API field name
  final Map<int, String> _settingIdToApiField = {
    0: 'alert_generic_notificaion', // Note: typo in API field name
    3: 'alert_app_update_notificaion', // Note: typo in API field name
    7: 'alert_payment_notification',
    // Add more mappings as needed based on your API requirements
    // 1: 'alert_sound', // Example
    // 2: 'alert_vibrate', // Example
  };
  List<SettingsGroup> get settingsGroups => [
    SettingsGroup(
      title: Resources.of(Get.context!).strings.settings,
      items: [
        SettingsModel(
          title: Resources.of(Get.context!).strings.generalNotification,
          icon: "",
          id: 0,
        ),
        SettingsModel(
          title: Resources.of(Get.context!).strings.sound,
          icon: "",
          id: 1,
        ),
        SettingsModel(
          title: Resources.of(Get.context!).strings.vibrate,
          icon: "",
          id: 2,
        ),

      ],
    ),
    SettingsGroup(
      title: Resources.of(Get.context!).strings.systemAndServicesUpdate,
      items: [
        SettingsModel(
          title: Resources.of(Get.context!).strings.appUpdates,
          icon: "",
          id: 3,
        ),
        SettingsModel(
          title: Resources.of(Get.context!).strings.billReminder,
          icon: "",
          id: 4,
        ),
        SettingsModel(
          title: Resources.of(Get.context!).strings.promotion,
          icon: "",
          id: 5,
        ),
        SettingsModel(
          title: Resources.of(Get.context!).strings.discountAvailable,
          icon: "",
          id: 6,
        ),
        SettingsModel(
          title: Resources.of(Get.context!).strings.paymentRequest,
          icon: "",
          id: 7,
        ),

      ],
    ),
    SettingsGroup(
      title: Resources.of(Get.context!).strings.other,
      items: [
        SettingsModel(
          title: Resources.of(Get.context!).strings.newJobsAvailable,
          icon: "",
          id: 8,
        ),
        SettingsModel(
          title: Resources.of(Get.context!).strings.newTalentsAvailable,
          icon: "",
          id: 9,
        ),
      ],
    ),

  ];



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> handleSettingsItemClick(bool? value, SettingsModel item) async {
    if (value != null) {
      item.checked.value = value;

      // Check if this setting has an API mapping
      final apiField = _settingIdToApiField[item.id];
      if (apiField != null) {
        await changeNotificationPreference(apiField, value);
      }
    }
  }

  Future<void> changeNotificationPreference(String field, bool value) async {
    try {
      final preferences = {field: value ? 1 : 0};
      final response = await _settingsRepository.changeNotificationPreferences(preferences);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Notification preference updated successfully',
          SnackBarStatus.SUCCESS,
        );
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to update notification preference',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating notification preference: $e',
        SnackBarStatus.ERROR,
      );
    }
  }

  Future<void> changeAllNotificationPreferences() async {
    try {
      final preferences = <String, int>{
        'alert_generic_notification': 0,
        'alert_app_update_notification': 1,
        'alert_payment_notification': 1,
        'alert_login_notification': 1,
        'alert_login_sms': 1,
      };

      final response = await _settingsRepository.changeNotificationPreferences(preferences);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'All notification preferences updated successfully',
          SnackBarStatus.SUCCESS,
        );
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to update notification preferences',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error updating notification preferences: $e',
        SnackBarStatus.ERROR,
      );
    }
  }
}
