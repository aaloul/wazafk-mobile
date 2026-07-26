import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/picker_field.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../add_job_controller.dart';

/// "Select Areas you cover" picker under the Location chips (design p185).
/// Opens the saved-addresses sheet; hidden for remote jobs, which carry no
/// address.
class JobAddressField extends StatelessWidget {
  const JobAddressField({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();

    return Obx(() {
      if (controller.selectedJobType.value == 'Remote') {
        return const SizedBox.shrink();
      }

      final address = controller.selectedAddress.value;

      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: PickerField(
          hint: context.resources.strings.selectAreasYouCover,
          value: address?.label,
          enabled: enabled,
          trailing: Image.asset(AppIcons.filterChevronDown, width: 20),
          onTap: () => SheetHelper.showSingleAddressSheet(
            context,
            selectedAddress: address,
            onAddressSelected: controller.selectAddress,
          ),
        ),
      );
    });
  }
}
