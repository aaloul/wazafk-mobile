import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/auth/create_account/components/step2/create_account_step_2.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/create_account_steps.dart';
import 'components/step1/create_account_step_1.dart';
import 'components/step3/create_account_step_3.dart';
import 'create_account_controller.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final CreateAccountController dataController = Get.put(
    CreateAccountController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopHeader(title: "Create Account"),
            SizedBox(height: 24),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () =>
                          CreateAccountSteps(index: dataController.index.value),
                    ),
                    SizedBox(height: 16),

                    Obx(
                      () => dataController.index.value == 0
                          ? CreateAccountStep1()
                          : dataController.index.value == 1
                          ? CreateAccountStep2()
                          : CreateAccountStep3(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
