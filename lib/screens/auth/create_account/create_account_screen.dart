import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/auth/create_account/components/step2/create_account_step_2.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

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

          if(dataController.faceImage.value == null && dataController.index.value == 3){
            dataController.index.value = dataController.index.value - 2;

          }else{
            dataController.index.value = dataController.index.value - 1;

          }

          return false;
        }
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopHeader(title: Resources
                  .of(context)
                  .strings
                  .createAccount, onBack: () {
                if (dataController.index.value > 0) {
                  dataController.index.value = dataController.index.value - 1;
                }
              },),
              SizedBox(height: 24),

              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                            () =>
                            CreateAccountSteps(index: dataController.index
                                .value),
                      ),
                      SizedBox(height: 16),

                      Obx(
                            () =>
                        dataController.index.value == 0
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
