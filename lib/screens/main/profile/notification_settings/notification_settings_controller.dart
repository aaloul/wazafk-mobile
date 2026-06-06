import 'package:get/get.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../repository/account/settings_repository.dart';

class NotificationSettingsController extends GetxController {
  final SettingsRepository _settingsRepository = SettingsRepository();

  // Notification Channels
  final RxBool channelPush = false.obs;
  final RxBool channelEmail = true.obs;
  final RxBool channelInApp = true.obs;

  // Employer
  final RxBool empRequests = true.obs;
  final RxBool empNewApplications = true.obs;
  final RxBool empJobUpdates = true.obs;

  // Freelancer
  final RxBool freelancerNewPostings = true.obs;
  final RxBool freelancerApplicationUpdates = true.obs;
  final RxBool freelancerJobRequests = true.obs;
  final RxBool freelancerJobUpdates = true.obs;

  // Sound & Alerts
  final RxBool soundOn = true.obs;
  final RxBool vibrateOn = true.obs;

  // General
  final RxBool generalMessages = true.obs;
  final RxBool generalPayments = true.obs;
  final RxBool generalReviews = true.obs;

  // Wazafk Announcements
  final RxBool annoucementsPromos = true.obs;
  final RxBool annoucementsDiscounts = true.obs;

  // Maps each Rx flag to the corresponding API field. UI-only flags map to null.
  late final Map<RxBool, String?> _apiField = {
    channelPush: 'alert_generic_notificaion',
    channelEmail: null,
    channelInApp: null,
    empRequests: null,
    empNewApplications: null,
    empJobUpdates: null,
    freelancerNewPostings: null,
    freelancerApplicationUpdates: null,
    freelancerJobRequests: null,
    freelancerJobUpdates: null,
    soundOn: null,
    vibrateOn: null,
    generalMessages: null,
    generalPayments: 'alert_payment_notification',
    generalReviews: null,
    annoucementsPromos: 'alert_app_update_notificaion',
    annoucementsDiscounts: null,
  };

  Future<void> toggle(RxBool flag, bool value) async {
    flag.value = value;
    final field = _apiField[flag];
    if (field != null) {
      await _post({field: value ? 1 : 0});
    }
  }

  Future<void> _post(Map<String, int> prefs) async {
    try {
      final response =
          await _settingsRepository.changeNotificationPreferences(prefs);
      if (response.success != true) {
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
}
