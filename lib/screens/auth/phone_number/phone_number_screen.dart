import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/auth/phone_number/phone_number_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../components/phone_text_field.dart';
import '../../../components/primary_text.dart';

class PhoneNumberScreen extends StatelessWidget {
  PhoneNumberScreen({super.key});

  final PhoneNumberController dataController = Get.put(PhoneNumberController());

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = Resources.of(context).strings;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
              PrimaryText(
                text: strings.loginRegister,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                textColor: colors.colorBlackMain,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  AppIcons.phoneScreenImage,
                  height: Get.width / 2,
                  width: Get.width / 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: PrimaryText(
                  text: '${strings.phoneNumber}*',
                  fontWeight: FontWeight.w500,
                  textColor: colors.colorGrey26,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              PhoneTextFiled(
                hint: strings.phoneNumber,
                controller: dataController.phoneController,
                onCCChanged: (cc) {
                  dataController.cc = cc;
                },
              ),
              const SizedBox(height: 14),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _RegisterNowLink(),
              ),
              const Spacer(),
              Obx(
                () => dataController.isLoading.value
                    ? const ProgressBar()
                    : PrimaryButton(
                        title: strings.continueBtn,
                        onPressed: () {
                          dataController.checkMemberExists();
                        },
                      ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    Get.offAllNamed(RouteConstant.mainNavigationScreen),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: PrimaryText(
                    text: strings.continueAsGuest,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    textColor: colors.colorPrimary,
                    textAlign: TextAlign.center,
                    isUnderLined: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _TermsFooter(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterNowLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${strings.dontHaveAccount} ',
            style: TextStyle(
              fontSize: 13,
              color: colors.colorGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  Get.toNamed(RouteConstant.createAccountScreen),
              child: Text(
                strings.registerNow,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.colorPrimary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: colors.colorPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: colors.colorGrey,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: strings.byContinuingAgreeTo),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.toNamed(
                RouteConstant.termsScreen,
                arguments: {'type': 'terms'},
              ),
              child: Text(
                strings.termsOfUse,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.colorPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          TextSpan(text: ' ${strings.and} '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.toNamed(
                RouteConstant.termsScreen,
                arguments: {'type': 'privacy'},
              ),
              child: Text(
                strings.privacyPolicy,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.colorPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
