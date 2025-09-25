import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'Prefs.dart';

Utils constants = Utils();

const title = "Constants";

class Utils {
  static final Utils _constants = Utils._i();

  factory Utils() {
    return _constants;
  }

  Utils._i();

  bool isKeyboardOpened() {
    return MediaQuery.of(Get.context!).viewInsets.bottom != 0;
  }

  bool isRTL() {
    return Prefs.getLanguage == 'ar';
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void dismissKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void showSnackBar(String message, SnackBarStatus status) {
    if (message == 'null' ||
        message.toLowerCase().contains('unauthorized') ||
        message.toLowerCase().contains(
          'CERTIFICATE_VERIFY_FAILED'.toLowerCase(),
        ) ||
        message.toLowerCase().contains('ClientException'.toLowerCase())) {
      print('Error=>$message');
      return;
    }
    switch (status) {
      case SnackBarStatus.ERROR:
        {
          print('Error=>$message');

          if (message.toLowerCase().contains('50')) {
            return;
          }

          toastification.show(
            style: ToastificationStyle.fillColored,
            backgroundColor: Get.context!.resources.color.colorRed,
            primaryColor: Get.context!.resources.color.colorRed,
            title: Text(
              message,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
        break;
      case SnackBarStatus.WARNING:
        {
          toastification.show(
            style: ToastificationStyle.fillColored,
            backgroundColor: Get.context!.resources.color.colorGreen2,
            primaryColor: Get.context!.resources.color.colorGreen2,
            title: Text(
              message,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
        break;

      case SnackBarStatus.SUCCESS:
        {
          toastification.show(
            style: ToastificationStyle.fillColored,
            type: ToastificationType.success,
            backgroundColor: Colors.green,
            primaryColor: Colors.green,
            title: Text(
              message,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
        break;
      case SnackBarStatus.INFO:
        {
          toastification.show(
            style: ToastificationStyle.fillColored,
            backgroundColor: Get.context!.resources.color.colorGrey,
            primaryColor: Get.context!.resources.color.colorGrey,
            title: Text(
              message,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
        break;
      case SnackBarStatus.DELETE:
        {
          toastification.show(
            style: ToastificationStyle.fillColored,
            backgroundColor: Get.context!.resources.color.colorRed,
            primaryColor: Get.context!.resources.color.colorRed,
            title: Text(
              message,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
        break;
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("dd/MM/yyyy");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}

// enum SnackBarStatus { ERROR, WARNING, SUCCESS, INFO, DELETE }

String getErrorMessage(String e) {
  if (e.contains('ClientException with SocketException') ||
      e.contains('Failed host lookup')) {
    return "No Internet Connection!";
  } else if (e.toString().toLowerCase() == 'unauthorized') {
    Prefs.clearUser();
    // Get.offAllNamed(RouteConstant.LoginScreen);
    return e.toString();
  } else {
    return e;
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

enum SnackBarStatus { ERROR, WARNING, SUCCESS, INFO, DELETE }
