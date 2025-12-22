import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../../model/SettingsModel.dart';

class NotificationSettingsController extends GetxController {
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

  void handleSettingsItemClick(bool? value, SettingsModel item) {
    if (value != null) {
      item.checked.value = value;
      print('Setting "${item.title}" changed to: $value');
      // TODO: Add API call here to save the notification preference
    }
  }
}
