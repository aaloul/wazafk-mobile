import 'package:flutter/cupertino.dart';
import 'package:get/utils.dart';
import 'package:wazafak_app/utils/res/strings/Strings.dart';

import 'colors/AppColors.dart';
import 'strings/ArabicStrings.dart';
import 'strings/EnglishStrings.dart';

class Resources {
  final BuildContext _context;

  Resources(this._context);

  Strings get strings {
    // It could be from the user preferences or even from the current locale
    Locale? locale = Get.locale;
    switch (locale?.languageCode ?? 'en') {
      case 'ar':
        return ArabicStrings();
      default:
        return EnglishStrings();
    }
  }

  AppColors get color {
    return AppColors();
  }

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
