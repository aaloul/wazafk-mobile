import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/book_service/book_service_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ServiceTypeRadioWidget extends StatelessWidget {
  const ServiceTypeRadioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookServiceController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: "Service Type",
          fontWeight: FontWeight.w900,
          fontSize: 16,
          textColor: context.resources.color.colorGrey,
        ),
        SizedBox(height: 12),
        Obx(
          () => Column(
            children: [
              _buildJobTypeRadio(context, controller, 'Onsite'),
              SizedBox(height: 8),
              _buildJobTypeRadio(context, controller, 'Remote'),
              SizedBox(height: 8),
              _buildJobTypeRadio(context, controller, 'Hybrid'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJobTypeRadio(
    BuildContext context,
    BookServiceController controller,
    String jobType,
  ) {
    final isSelected = controller.selectedServiceType.value == jobType;

    return GestureDetector(
      onTap: () {
        controller.selectServiceType(jobType);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.resources.color.colorGreen4
              : context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? context.resources.color.colorGrey4
                : context.resources.color.colorGrey4,
            width: isSelected ? 1 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: PrimaryText(
                text: jobType,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                textColor: context.resources.color.colorGrey8,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorGrey2,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.resources.color.colorPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
