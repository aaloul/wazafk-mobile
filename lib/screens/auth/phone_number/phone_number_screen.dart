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
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                PrimaryText(
                  text: Resources.of(context).strings.loginRegister,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlackMain,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    AppIcons.phoneScreenImage,
                    height: Get.width / 2,
                    width: Get.width / 1.5,
                  ),
                ),

                SizedBox(height: 32),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: '${context.resources.strings.phoneNumber}*',
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorGrey26,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),

                    PhoneTextFiled(
                      hint: Resources.of(context).strings.phoneNumber,
                      controller: dataController.phoneController,
                      onCCChanged: (cc) {
                        dataController.cc = cc;
                      },
                    ),

                    SizedBox(height: 24),

                    Obx(
                      () => dataController.isLoading.value
                          ? ProgressBar()
                          : PrimaryButton(
                              title: Resources.of(context).strings.continueBtn,
                              onPressed: () {
                                dataController.checkMemberExists();
                              },
                            ),
                    ),
                    SizedBox(height: 24),

                    GestureDetector(
                      onTap: () {},
                      child: Text.rich(
                        TextSpan(
                          text: Resources.of(
                            context,
                          ).strings.messageAndDateRates,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.resources.color.colorGrey3,
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    RouteConstant.termsScreen,
                                    arguments: {'type': 'terms'},
                                  );
                                },
                                child: Text(
                                  Resources.of(context).strings.termsOfUse,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: context.resources.color.colorPrimary,
                                    // decoration: TextDecoration.combine([
                                    //   TextDecoration.underline,
                                    // ]),
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: Resources.of(context).strings.and,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context.resources.color.colorGrey3,
                              ),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    RouteConstant.termsScreen,
                                    arguments: {'type': 'privacy'},
                                  );
                                },
                                child: Text(
                                  Resources.of(context).strings.privacyPolicy,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: context.resources.color.colorPrimary,
                                    // decoration: TextDecoration.combine([
                                    //   TextDecoration.underline,
                                    // ]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
