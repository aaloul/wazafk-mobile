import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/auth/phone_number/phone_number_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/labeled_text_field.dart';
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
                SizedBox(height: 80),

                Center(
                  child: Image.asset(
                    AppIcons.phoneScreenImage,
                    height: Get.width / 2,
                    width: Get.width / 1.5,
                  ),
                ),

                SizedBox(height: 32),

                PrimaryText(
                  text: "Login/Register",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlackMain,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24),

                LabeledTextFiled(
                  label: 'Phone Number',
                  hint: '',
                  isPassword: false,
                  controller: dataController.phoneController,
                  isMandatory: true,
                  inputType: TextInputType.phone,
                ),
                SizedBox(height: 20),

                GestureDetector(
                  onTap: () {},
                  child: Text.rich(
                    TextSpan(
                        text: "Message and date rates may apply. By continuing, you agree to our ",
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
                                "Terms of Use",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: context.resources.color.colorPrimary,
                                  decoration: TextDecoration.combine([
                                    TextDecoration.underline,
                                  ]),
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: " and ",
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
                                "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: context.resources.color.colorPrimary,
                                  decoration: TextDecoration.combine([
                                    TextDecoration.underline,
                                  ]),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),


                SizedBox(height: 40),

                Obx(() =>
                dataController.isLoading.value ? ProgressBar() : PrimaryButton(
                    title: "Continue", onPressed: () {
                  dataController.checkMemberExists();
                }),),
                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
