import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../../model/SettingsModel.dart';
import '../../../../utils/res/AppIcons.dart';

class ShareAppController extends GetxController {
  List<SettingsModel> get settingItems => [
    SettingsModel(
      title: Resources.of(Get.context!).strings.download,
      desc: Resources.of(Get.context!).strings.enterEmailAssociatedWithAccount,
      icon: AppIcons.shareDownload,
      id: 0,
    ),
    SettingsModel(
      title: Resources.of(Get.context!).strings.verification,
      desc: Resources.of(Get.context!).strings.enterEmailAssociatedWithAccount,
      icon: AppIcons.shareVerification,
      id: 1,
    ),
    SettingsModel(
      title: Resources.of(Get.context!).strings.hiredOrWorked,
      desc: Resources.of(Get.context!).strings.enterEmailAssociatedWithAccount,
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
