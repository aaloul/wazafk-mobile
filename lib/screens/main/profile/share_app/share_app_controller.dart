import 'package:get/get.dart';

import '../../../../model/SettingsModel.dart';
import '../../../../utils/res/AppIcons.dart';

class ShareAppController extends GetxController {
  final List<SettingsModel> settingItems = [
    SettingsModel(
      title: 'Download',
      desc:
          "Enter the email associated with your account and we’ll send an email with code to reset your password. ",
      icon: AppIcons.shareDownload,
      id: 0,
    ),
    SettingsModel(
      title: 'Verification',
      desc:
          "Enter the email associated with your account and we’ll send an email with code to reset your password. ",
      icon: AppIcons.shareVerification,
      id: 1,
    ),
    SettingsModel(
      title: 'Hired or Worked',
      desc:
          "Enter the email associated with your account and we’ll send an email with code to reset your password.",
      icon: AppIcons.shareHired,
      id: 2,
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
}
