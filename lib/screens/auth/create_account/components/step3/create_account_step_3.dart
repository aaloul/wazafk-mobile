import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/primary_button.dart';
import '../../create_account_controller.dart';
import 'interest_item.dart';

class CreateAccountStep3 extends StatelessWidget {
  CreateAccountStep3({super.key});

  final CreateAccountController dataController = Get.put(
    CreateAccountController(),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FocusDetector(
        onFocusGained: () {
          if (dataController.interests.isEmpty) {
            dataController.getInterestOptions();
          }
        },
        child: Column(
          children: [
            SizedBox(height: 12),

            PrimaryText(
              text: "Choose Interest",
              fontSize: 22,
              fontWeight: FontWeight.w700,
              textColor: context.resources.color.colorBlackMain,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            PrimaryText(
              text: "Choose up to 5 interests!.",
              fontSize: 16,
              fontWeight: FontWeight.w900,
              textColor: context.resources.color.colorGrey,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            Expanded(
              child: Obx(
                () => dataController.isInterestOptionsLoading.value
                    ? ProgressBar()
                    : Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.start,
                        spacing: 8,
                        runSpacing: 8,
                        direction: Axis.horizontal,
                        children: [
                          ...List.generate(
                            dataController.interests.value.length,
                            (index) => InterestItem(
                              option: dataController.interests[index],
                              onSelect: (o) {
                                dataController.interests
                                    .firstWhere(
                                      (opt) =>
                                          o.hashcode.toString() ==
                                          opt.hashcode.toString(),
                                    )
                                    .selected
                                    .value = !dataController.interests
                                    .firstWhere(
                                      (opt) =>
                                          o.hashcode.toString() ==
                                          opt.hashcode.toString(),
                                    )
                                    .selected
                                    .value;
                                dataController.interests.refresh();
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            SizedBox(height: 16),

            Obx(
              () => dataController.isRegistering.value
                  ? ProgressBar()
                  : PrimaryButton(
                      title: "Start Your Journey",
                      onPressed: () {
                        dataController.verifyStep3();
                      },
                    ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
