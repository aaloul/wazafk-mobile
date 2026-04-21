import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/screens/auth/create_account/components/step2/create_account_step_2.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/primary_text.dart';
import '../../../utils/res/AppIcons.dart';
import '../../../utils/utils.dart';
import 'components/create_account_steps.dart';
import 'components/step1/create_account_step_1.dart';
import 'components/step3/create_account_step_3.dart';
import 'components/step4/create_account_step_4.dart';
import 'create_account_controller.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final CreateAccountController dataController = Get.put(
    CreateAccountController(),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (dataController.index.value == 0) {
          SystemNavigator.pop();
          return false;
        } else {
          if (dataController.faceImage.value == null &&
              dataController.index.value == 3) {
            dataController.index.value = dataController.index.value - 2;
          } else {
            dataController.index.value = dataController.index.value - 1;
          }

          return false;
        }
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background2,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                decoration: BoxDecoration(
                  color: context.resources.color.colorWhite,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       GestureDetector(
                            onTap: () {
                              if (dataController.index.value == 0) {
                                SystemNavigator.pop();
                              } else {
                                if (dataController.faceImage.value == null &&
                                    dataController.index.value == 3) {
                                  dataController.index.value =
                                      dataController.index.value - 2;
                                } else {
                                  dataController.index.value =
                                      dataController.index.value - 1;
                                }
                              }
                            },
                            child: RotatedBox(
                              quarterTurns: Utils().isRTL() ? 2 : 0,
                              child: Image.asset(
                                AppIcons.back2,
                                width: 32,
                              ),
                          )),



                        PrimaryText(
                          textAlign: TextAlign.center,
                          text: context.resources.strings.createAccount,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          textColor:context.resources.color.colorGrey,
                        ),


                        SizedBox()



                      ],
                    ),

                    SizedBox(height: 16),

                    Obx(
                          () => CreateAccountSteps(
                        index: dataController.index.value,
                      ),
                    ),
                  ],
                ),
              ),



              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 16),

                      Obx(
                        () => dataController.index.value == 0
                            ? CreateAccountStep1()
                            : dataController.index.value == 1
                            ? CreateAccountStep2()
                            : dataController.index.value == 2
                            ? CreateAccountStep3()
                            : CreateAccountStep4(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
