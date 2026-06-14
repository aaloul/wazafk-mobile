import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/primary_button.dart';
import '../components/primary_text.dart';
import '../constants/route_constant.dart';
import 'Prefs.dart';
import 'res/AppContextExtension.dart';
import 'res/Resources.dart';

/// Guards authenticated actions from guest users. Returns `true` when the user
/// is logged in (proceed); otherwise shows the "login required" popup and
/// returns `false`. Works from both widgets and GetX controllers (it resolves
/// the context via [Get.context]).
bool requireLogin() {
  if (Prefs.getLoggedIn) return true;
  showLoginRequiredDialog();
  return false;
}

/// Popup prompting a guest to log in / register to continue.
void showLoginRequiredDialog() {
  final context = Get.context;
  if (context == null) return;

  final colors = context.resources.color;
  final strings = Resources.of(context).strings;

  Get.dialog(
    Dialog(
      backgroundColor: colors.colorWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.colorPrimaryLight,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: colors.colorPrimary,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryText(
              text: strings.loginRequired,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: colors.colorBlack,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            PrimaryText(
              text: strings.loginRequiredMessage,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: colors.colorGrey7,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              title: strings.login,
              height: 50,
              borderRadius: 12,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              onPressed: () {
                Get.back();
                Get.toNamed(RouteConstant.phoneNumberScreen);
              },
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Get.back(),
              child: PrimaryText(
                text: strings.cancel,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: colors.colorGrey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
