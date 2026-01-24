import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

class JobAddressChooseWidget extends StatelessWidget {
  const JobAddressChooseWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PrimaryText(
              text: context.resources.strings.location,
              textColor: context.resources.color.colorGrey3,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            const SizedBox(width: 4),
            PrimaryText(
              text: '*',
              textColor: context.resources.color.colorGrey3,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(
          () => IgnorePointer(
            ignoring: !enabled,
            child: GestureDetector(
              onTap: () {
                SheetHelper.showSingleAddressSheet(
                  context,
                  selectedAddress: controller.selectedAddress.value,
                  onAddressSelected: (address) {
                    controller.selectAddress(address);
                  },
                );
              },
              child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.resources.color.colorWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.resources.color.colorGrey2,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: PrimaryText(
                      text:
                          controller.selectedAddress.value?.label ??
                          context.resources.strings.selectAddress,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: controller.selectedAddress.value != null
                          ? context.resources.color.colorGrey
                          : context.resources.color.colorGrey8,
                    ),
                  ),
                  if (enabled)
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: context.resources.color.colorGrey,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
          ),
        ),
      ],
    );
  }
}
