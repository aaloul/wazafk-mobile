import 'package:flutter/material.dart';
import 'package:wazafak_app/components/sheets/addresses_sheet.dart';
import 'package:wazafak_app/components/sheets/areas_sheet.dart';
import 'package:wazafak_app/components/sheets/change_language_sheet.dart';
import 'package:wazafak_app/components/sheets/filter_sheet.dart';
import 'package:wazafak_app/components/sheets/invite_sheet.dart';
import 'package:wazafak_app/components/sheets/payment_method_sheet.dart';
import 'package:wazafak_app/components/sheets/skills_sheet.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/model/AreasResponse.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/screens/main/profile/wallet/top_up/top_up_controller.dart';
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

  static void showFilterSheet(
    BuildContext context, {
    required HomeFilters initialFilters,
    required ValueChanged<HomeFilters> onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.08,
          ),
          child: FilterSheet(
            initialFilters: initialFilters,
            onApply: onApply,
          ),
        );
      },
    );
  }

  static Future<PaymentMethodOption?> showPaymentMethodSheet(
    BuildContext context, {
    required List<PaymentMethodOption> methods,
  }) {
    return showModalBottomSheet<PaymentMethodOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentMethodSheet(methods: methods),
    );
  }

  static void showInviteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InviteSheet(),
    );
  }

  static void showChangeLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.resources.color.colorWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: const ChangeLanguageSheet(),
        );
      },
    );
  }

  static void showAreasSheet(
    BuildContext context, {
    required List<AreaModel> selectedAreas,
    required Function(List<AreaModel>) onAreasSelected,
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
            child: AreasSheet(
              selectedAreas: selectedAreas,
              onAreasSelected: onAreasSelected,
            ),
          ),
        );
      },
    );
  }
}
