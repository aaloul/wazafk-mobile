import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/form_choice_chip.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/primary_text_field.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../add_service_controller.dart';

/// "Approximate Rate *" — amount field plus the pricing-type dropdown pill
/// ("/ Project" or "/ Hour") shown beside it (design p112).
class ServiceRateRow extends StatelessWidget {
  const ServiceRateRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddServiceController>();
    final strings = context.resources.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: strings.approximateRate, isMandatory: true),
        const SizedBox(height: 8),
        Obx(() {
          final isHourly =
              controller.selectedPricingType.value == strings.hourlyRateOption;
          return Row(
            children: [
              Expanded(
                child: PrimaryTextField(
                  key: ValueKey(isHourly),
                  controller: isHourly
                      ? controller.hourlyRateController
                      : controller.totalPriceController,
                  hint: strings.amountInUsd,
                  inputType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              _PricingTypePill(
                label: isHourly ? strings.perHour : strings.perProject,
                onTap: () => _pickPricingType(context, controller),
              ),
            ],
          );
        }),
      ],
    );
  }

  void _pickPricingType(BuildContext context, AddServiceController controller) {
    final colors = context.resources.color;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: colors.colorWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                PrimaryText(
                  text: context.resources.strings.pricingType,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: colors.colorBlack4,
                ),
                const SizedBox(height: 12),
                for (final option in controller.pricingTypeOptions)
                  Obx(
                    () => ListTile(
                      title: PrimaryText(
                        text: option,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        textColor:
                            controller.selectedPricingType.value == option
                                ? colors.colorPrimary
                                : colors.colorBlack4,
                      ),
                      trailing: controller.selectedPricingType.value == option
                          ? Image.asset(AppIcons.checkCircle, width: 20)
                          : null,
                      onTap: () {
                        controller.selectedPricingType.value = option;
                        Navigator.pop(sheetContext);
                      },
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PricingTypePill extends StatelessWidget {
  const _PricingTypePill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.colorGrey25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryText(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: colors.colorGrey26,
            ),
            const SizedBox(width: 8),
            Image.asset(AppIcons.filterChevronDown, width: 20),
          ],
        ),
      ),
    );
  }
}
