import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wazafak_app/repository/app/banners_repository.dart';

import '../../../utils/Prefs.dart';
import '../../../utils/utils.dart';

class SplashController extends GetxController {
  final BannersRepository _bannersRepository = BannersRepository();

  var isBannersLoading = false.obs;

  Future<void> getBanners() async {
    isBannersLoading(true);
    try {
      final response = await _bannersRepository.getBanners("S");
      if (response.success ?? false) {
        Prefs.setStartBanners(response.data ?? []);
      }
      isBannersLoading(false);
    } catch (e) {
      isBannersLoading(false);

      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    getBanners();
    initPlatformState();
    saveDeviceId();
  }

  Future<void> initPlatformState() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Prefs.setAppVersion(packageInfo.version);
    Prefs.setAppBuild(packageInfo.buildNumber);

    if (GetPlatform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      Prefs.setDeviceBrand('${androidInfo.manufacturer} ${androidInfo.brand}');
      Prefs.setDeviceModel(androidInfo.model);
      Prefs.setOSVersion(androidInfo.version.release);
    } else if (GetPlatform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      Prefs.setDeviceBrand(iosInfo.name);
      Prefs.setDeviceModel(iosInfo.model);
      Prefs.setOSVersion(iosInfo.systemVersion);
    }
  }

  Future<void> saveDeviceId() async {
    try {
      String udid = await FlutterUdid.udid;
      Prefs.setDeviceId(udid);
    } on PlatformException {}
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}
}
