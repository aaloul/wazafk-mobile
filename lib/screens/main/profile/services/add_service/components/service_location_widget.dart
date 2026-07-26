import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/form_choice_chip.dart';
import 'package:wazafak_app/components/picker_field.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../add_service_controller.dart';

/// "Location" — Remote / On-site chips followed by the areas picker
/// (design p112). Areas only apply off-remote, so the picker is hidden for
/// remote services. Hybrid is not in the new design and only shows up when an
/// existing hybrid service is being edited.
class ServiceLocationWidget extends StatelessWidget {
  const ServiceLocationWidget({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddServiceController>();
    final strings = context.resources.strings;

    return Obx(() {
      final selected = controller.selectedWorkLocationType.value;
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

      final areas = controller.selectedAreas;

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
                    onTap: () => controller.selectWorkLocationType(type),
                  ),
                  if (type != types.last) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
          if (selected != 'Remote') ...[
            const SizedBox(height: 10),
            PickerField(
              hint: strings.selectAreasYouCover,
              value: areas.map((a) => a.name ?? '').join(', '),
              enabled: enabled,
              trailing: Image.asset(AppIcons.filterChevronDown, width: 20),
              onTap: () => SheetHelper.showAreasSheet(
                context,
                selectedAreas: areas.toList(),
                onAreasSelected: (selectedAreas) {
                  controller.selectedAreas.value = selectedAreas;
                },
              ),
            ),
          ],
        ],
      );
    });
  }
}
