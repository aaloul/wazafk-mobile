import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/form_choice_chip.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../add_job_controller.dart';

/// "Location" — Remote / On-site chips (design p185). Hybrid is not part of the
/// new design, so it only appears when an existing hybrid job is being edited.
class JobLocationTypeWidget extends StatelessWidget {
  const JobLocationTypeWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddJobController>();
    final strings = context.resources.strings;

    return Obx(() {
      final selected = controller.selectedJobType.value;
      final types = <String>[
        'Remote',
        'Onsite',
        if (selected == 'Hybrid') 'Hybrid',
      ];

      String label(String type) {
        switch (type) {
          case 'Remote':
            return strings.remote;
          case 'Hybrid':
            return strings.hybrid;
          default:
            return strings.onSite;
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldLabel(text: strings.location),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final type in types) ...[
                  FormChoiceChip(
                    label: label(type),
                    selected: selected == type,
                    enabled: enabled,
                    minWidth: 80,
                    fontWeight: FontWeight.w500,
                    onTap: () => controller.selectJobType(type),
                  ),
                  if (type != types.last) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }
}
