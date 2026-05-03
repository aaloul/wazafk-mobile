import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/book_service/book_service_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ServiceTypeRadioWidget extends StatelessWidget {
  const ServiceTypeRadioWidget({super.key});

  static const _types = ['Onsite', 'Remote', 'Hybrid'];

  Widget _buildChip(
      BuildContext context, BookServiceController controller, String type) {
    final isSelected = controller.selectedServiceType.value == type;
    return GestureDetector(
      onTap: () => controller.selectServiceType(type),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
            text: _label(context, type),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            textColor: isSelected
                ? context.resources.color.colorPrimary
                : context.resources.color.colorBlack4,
          ),
        ),
      ),
    );
  }

  String _label(BuildContext context, String type) {
    switch (type) {
      case 'Remote':
        return context.resources.strings.remote;
      case 'Hybrid':
        return context.resources.strings.hybrid;
      case 'Onsite':
        return context.resources.strings.onsite;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookServiceController>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: context.resources.strings.serviceType,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            textColor: context.resources.color.colorBlack4,
          ),
          const SizedBox(height: 12),
          Obx(
            () => Row(
              children: _types
                  .expand((type) => [
                        _buildChip(context, controller, type),
                        const SizedBox(width: 8),
                      ])
                  .toList()
                ..removeLast(),
            ),
          ),
        ],
      ),
    );
  }
}
