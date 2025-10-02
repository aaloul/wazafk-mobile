import 'package:get/get.dart';

import '../../../../model/SettingsModel.dart';

class NotificationSettingsController extends GetxController {

  final List<SettingsGroup> settingsGroups = [
    SettingsGroup(
      title: 'Settings',
      items: [
        SettingsModel(
          title: 'General Notification',
          icon: "",
          id: 0,
        ),
        SettingsModel(
          title: 'Sound',
          icon: "",
          id: 1,
        ),
        SettingsModel(
          title: 'vibrate',
          icon: "",
          id: 2,
        ),

      ],
    ),
    SettingsGroup(
      title: 'System & Services Update',
      items: [
        SettingsModel(
          title: 'App Updates',
          icon: "",
          id: 3,
        ),
        SettingsModel(
          title: 'Bill Reminder',
          icon: "",
          id: 4,
        ),
        SettingsModel(
          title: 'Promotion',
          icon: "",
          id: 5,
        ),
        SettingsModel(
          title: 'Discount Available',
          icon: "",
          id: 6,
        ),
        SettingsModel(
          title: 'Payment Request',
          icon: "",
          id: 7,
        ),

      ],
    ),
    SettingsGroup(
      title: 'Other',
      items: [
        SettingsModel(
          title: 'New Jobs Available',
          icon: "",
          id: 8,
        ),
        SettingsModel(
          title: 'New Talents Available',
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
