import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wazafak_app/repository/app/banners_repository.dart';
import 'package:wazafak_app/repository/app/privacy_repository.dart';
import 'package:wazafak_app/repository/app/terms_repository.dart';

import '../../../constants/route_constant.dart';
import '../../../utils/Prefs.dart';
import '../../../utils/utils.dart';

class SplashController extends GetxController {
  final BannersRepository _bannersRepository = BannersRepository();
  final PrivacyRepository _privacyRepository = PrivacyRepository();
  final TermsRepository _termsRepository = TermsRepository();

  var isBannersLoading = false.obs;
  var isPrivacyLoading = false.obs;
  var isTermsLoading = false.obs;

  Future<void> getBanners() async {
    isBannersLoading(true);
    try {
      final response = await _bannersRepository.getBanners("S");
      if (response.success ?? false) {
        Prefs.setStartBanners(response.data ?? []);

        if (!Prefs.getLoggedIn) {
          Get.offAllNamed(RouteConstant.onboardingScreen);
        }
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

  Future<void> getPrivacyPolicy() async {
    isPrivacyLoading(true);
    try {
      final response = await _privacyRepository.getPrivacyPolicy();
      if (response.success ?? false) {
        Prefs.setPrivacyPolicy(response.data?.content ?? '');
        Prefs.setPrivacyPolicyTitle(response.data?.title ?? '');
      }
      isPrivacyLoading(false);
    } catch (e) {
      isPrivacyLoading(false);

      constants.showSnackBar(
        getErrorMessage(e.toString()).toString(),
        SnackBarStatus.ERROR,
      );
    }
  }

  Future<void> getTermsAndConditions() async {
    isTermsLoading(true);
    try {
      final response = await _termsRepository.getTermsAndConditions();
      if (response.success ?? false) {
        Prefs.setTermsAndConditions(response.data?.content ?? '');
        Prefs.setTermsAndConditionsTitle(response.data?.title ?? '');
      }
      isTermsLoading(false);
    } catch (e) {
      isTermsLoading(false);

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
    getPrivacyPolicy();
    getTermsAndConditions();
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
