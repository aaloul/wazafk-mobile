import 'package:flutter/material.dart';
import 'package:wazafak_app/components/sheets/addresses_sheet.dart';
import 'package:wazafak_app/components/sheets/skills_sheet.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class SheetHelper {
  static void showSkillsSheet(
    BuildContext context, {
    required List<Skill> selectedSkills,
    required Function(List<Skill>) onSkillsSelected,
    List<Skill>? availableSkills,
    bool isLoadingSkills = false,
  }) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: context.resources.color.background2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SizedBox(
            height: 570,
            child: SkillsSheet(
              selectedSkills: selectedSkills,
              onSkillsSelected: onSkillsSelected,
              availableSkills: availableSkills,
              isLoadingSkills: isLoadingSkills,
            ),
          ),
        );
      },
    );
  }

  static void showAddressesSheet(
    BuildContext context, {
    required List<Address> selectedAddresses,
    required Function(List<Address>) onAddressesSelected,
  }) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: context.resources.color.background2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SizedBox(
            height: 570,
            child: AddressesSheet(
              selectedAddresses: selectedAddresses,
              onAddressesSelected: onAddressesSelected,
            ),
          ),
        );
      },
    );
  }

  static void showSingleAddressSheet(
    BuildContext context, {
    required Address? selectedAddress,
    required Function(Address) onAddressSelected,
  }) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: context.resources.color.background2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SizedBox(
            height: 570,
            child: AddressesSheet(
              selectedAddresses: selectedAddress != null
                  ? [selectedAddress]
                  : [],
              onAddressesSelected: (addresses) {
                if (addresses.isNotEmpty) {
                  onAddressSelected(addresses.first);
                }
              },
              singleSelect: true,
            ),
          ),
        );
      },
    );
  }
}
