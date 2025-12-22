import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/profile/packages/add_package/add_package_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class ServicesSelectionBottomSheet extends StatelessWidget {
  const ServicesSelectionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ServicesSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPackageController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.resources.color.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with drag indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorGrey8,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 48),
                    PrimaryText(
                      text: 'Select Services',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textColor: context.resources.color.colorPrimary,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: context.resources.color.colorGrey,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: context.resources.color.colorGrey8),

          SizedBox(height: 16),

          // Services list
          Expanded(
            child: Obx(() {
              if (controller.isLoadingServices.value) {
                return Center(child: ProgressBar());
              }

              if (controller.services.isEmpty) {
                return Center(
                  child: PrimaryText(
                    text: 'No services available',
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.services.length,
                      itemBuilder: (context, index) {
                        final service = controller.services[index];

                        return Obx(() {
                          final isSelected = controller.isServiceSelected(
                            service,
                          );

                          return GestureDetector(
                            onTap: () {
                              controller.toggleServiceSelection(service);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.resources.color.colorPrimary
                                          .withOpacity(0.1)
                                    : context.resources.color.colorWhite,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? context.resources.color.colorPrimary
                                      : context.resources.color.colorGrey8,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Checkbox
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? context.resources.color.colorPrimary
                                          : context.resources.color.colorWhite,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isSelected
                                            ? context
                                                  .resources
                                                  .color
                                                  .colorPrimary
                                            : context
                                                  .resources
                                                  .color
                                                  .colorGrey8,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 16,
                                            color: context
                                                .resources
                                                .color
                                                .colorWhite,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 12),

                                  // Service info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PrimaryText(
                                          text: service.title ?? 'Untitled',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorPrimary,
                                        ),
                                        if (service.categoryName != null) ...[
                                          SizedBox(height: 4),
                                          PrimaryText(
                                            text: service.categoryName!,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey,
                                          ),
                                        ],
                                        if (service.unitPrice != null) ...[
                                          SizedBox(height: 4),
                                          PrimaryText(
                                            text: '\$${service.unitPrice}',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorPrimary,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              );
            }),
          ),

          // Save button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: context.resources.color.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Obx(
                    () => controller.selectedServices.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: PrimaryText(
                              text:
                                  '${controller.selectedServices.length} service(s) selected',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              textColor: context.resources.color.colorPrimary,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  PrimaryButton(
                    title: Resources.of(context).strings.confirmSelection,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
