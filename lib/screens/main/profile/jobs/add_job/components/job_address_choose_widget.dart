import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

class JobAddressChooseWidget extends StatelessWidget {
  const JobAddressChooseWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();
    final homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Row(
          children: [
            PrimaryText(
              text: context.resources.strings.location,
              textColor: context.resources.color.colorGrey26,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            if (controller.selectedJobType.value != 'Remote') ...[
              const SizedBox(width: 4),
              PrimaryText(
                text: '*',
                textColor: context.resources.color.colorGrey26,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ],
          ],
        )),
        SizedBox(height: 8),
        Obx(() {
          if (homeController.isLoadingAddresses.value) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: SizedBox(width: 20, height: 20, child: ProgressBar())),
            );
          }
          if (homeController.addresses.isEmpty) return SizedBox.shrink();

          final selectedHashcode = controller.selectedAddress.value?.hashcode;

          return SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: homeController.addresses.length,
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (context, index) {
                final address = homeController.addresses[index];
                final isSelected = selectedHashcode == address.hashcode;
                return GestureDetector(
                  onTap: () {
                    if (enabled) controller.selectAddress(address);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.resources.color.colorPrimary.withAlpha(16)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? context.resources.color.colorPrimary
                            : context.resources.color.colorGrey25,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: PrimaryText(
                        text: address.label ?? '',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        textColor: isSelected
                            ? context.resources.color.colorPrimary
                            : context.resources.color.colorBlack4,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
