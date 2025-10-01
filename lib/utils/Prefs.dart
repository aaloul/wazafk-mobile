import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:wazafak_app/model/BannersResponse.dart';

import '../networking/Endpoints.dart';
import 'Const.dart';

class Prefs {
  static final box = GetStorage('USER');

  static bool get getLoggedIn => box.read(Const.IS_LOGGED_IN) ?? false;

  static void setLoggedIn(bool value) => box.write(Const.IS_LOGGED_IN, value);

  static bool get getFirstLunch => box.read(Const.IS_FIRST_LUNCH) ?? true;

  static void setFirstLunch(bool value) =>
      box.write(Const.IS_FIRST_LUNCH, value);

  static bool get getFirstRun => box.read(Const.FIRST_RUN) ?? true;

  static void setFirstRun(bool value) => box.write(Const.FIRST_RUN, value);

  static bool get getRememberLoggedIn =>
      box.read(Const.REMEMBER_LOGGED_IN) ?? false;

  static void setRememberLoggedIn(bool value) =>
      box.write(Const.REMEMBER_LOGGED_IN, value);

  static String get getDeviceId => box.read(Const.DEVICE_ID) ?? '';

  static void setDeviceId(String value) => box.write(Const.DEVICE_ID, value);

  static String get getAppVersion => box.read(Const.APP_VERSION) ?? '';

  static void setAppVersion(String value) =>
      box.write(Const.APP_VERSION, value);

  static String get getAppBuild => box.read(Const.APP_BUILD) ?? '';

  static void setAppBuild(String value) => box.write(Const.APP_BUILD, value);

  static String get getOSVersion => box.read(Const.OS_VERSION) ?? '';

  static void setOSVersion(String value) => box.write(Const.OS_VERSION, value);

  static String get getDeviceModel => box.read(Const.DEVICE_MODEL) ?? '';

  static void setDeviceModel(String value) =>
      box.write(Const.DEVICE_MODEL, value);

  static String get getDeviceBrand => box.read(Const.DEVICE_BRAND) ?? '';

  static void setDeviceBrand(String value) =>
      box.write(Const.DEVICE_BRAND, value);

  static String get getLanguage => box.read(Const.LANGUAGE) ?? 'en';

  static void setLanguage(String value) => box.write(Const.LANGUAGE, value);

  static void setId(String value) => box.write(Const.ID, value);

  static String get getId => box.read(Const.ID) ?? '';

  static String get getToken => box.read(Const.TOKEN) ?? '';

  static void setToken(String value) => box.write(Const.TOKEN, value);

  static String get getFullName => box.read(Const.FULL_NAME) ?? '';

  static void setFullName(String value) => box.write(Const.FULL_NAME, value);

  static String get getFName => box.read(Const.F_NAME) ?? '';

  static void setFName(String value) => box.write(Const.F_NAME, value);

  static String get getLName => box.read(Const.L_NAME) ?? '';

  static void setLName(String value) => box.write(Const.L_NAME, value);

  static String get getDob => box.read(Const.DOB) ?? '';

  static void setDob(String value) => box.write(Const.DOB, value);

  static String get getGender => box.read(Const.GENDER) ?? '';

  static void setGender(String value) => box.write(Const.GENDER, value);

  static String get getEmail => box.read(Const.EMAIL) ?? '';

  static void setEmail(String value) => box.write(Const.EMAIL, value);

  static String get getEnvUrl => box.read(Const.ENV_URL) ?? Endpoints.base_url;

  static void setEnvUrl(String value) => box.write(Const.ENV_URL, value);

  static String get getRemoteVersion =>
      box.read(Const.REMOTE_VERSION) ?? '1.0.0';

  static void setRemoteVersion(String value) =>
      box.write(Const.REMOTE_VERSION, value);

  static List<BoardingBanner> get getStartBanners {
    List<BoardingBanner> qs = [];

    qs = (json.decode(box.read(Const.START_BANNERS)) as List)
        .map((data) => BoardingBanner.fromJson(data))
        .toList();

    return qs ?? [];
  }

  static void setStartBanners(List<BoardingBanner> listNeedToSave) {
    var json = jsonEncode(listNeedToSave.map((e) => e.toJson()).toList());
    box.write(Const.START_BANNERS, json.toString());
  }

  static bool get getOnboardingCompleted => box.read(Const.ONBOARDING_COMPLETED) ?? false;

  static void setOnboardingCompleted(bool value) => box.write(Const.ONBOARDING_COMPLETED, value);

  static String get getPrivacyPolicy => box.read(Const.PRIVACY_POLICY) ?? '';

  static void setPrivacyPolicy(String value) =>
      box.write(Const.PRIVACY_POLICY, value);

  static String get getPrivacyPolicyTitle =>
      box.read(Const.PRIVACY_POLICY_TITLE) ?? '';

  static void setPrivacyPolicyTitle(String value) =>
      box.write(Const.PRIVACY_POLICY_TITLE, value);

  static String get getTermsAndConditions =>
      box.read(Const.TERMS_AND_CONDITIONS) ?? '';

  static void setTermsAndConditions(String value) =>
      box.write(Const.TERMS_AND_CONDITIONS, value);

  static String get getTermsAndConditionsTitle =>
      box.read(Const.TERMS_AND_CONDITIONS_TITLE) ?? '';

  static void setTermsAndConditionsTitle(String value) =>
      box.write(Const.TERMS_AND_CONDITIONS_TITLE, value);

  //
  // static void saveUser(User user) {
  //   setLoggedIn(true);
  //   setId(user.id.toString());
  //   setEmail(user.email.toString());
  //   setFullName(user.fullName.toString());
  //   setFName(user.firstName.toString());
  //   setLName(user.lastName.toString());
  //   setDob(user.dob ?? '');
  //
  // }

  static void clearUser() {
    setLoggedIn(false);
    setId('');
    setDob('');
    setEmail('');
    setFullName('');
    setFName('');
    setLName('');
    setFullName('');
    setGender('');
    setToken('');
  }
}
