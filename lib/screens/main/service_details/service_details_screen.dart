import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/service_details/components/service_details_header.dart';
import 'package:wazafak_app/screens/main/service_details/service_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceDetailsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final service = controller.service.value;
                if (service == null) {
                  return Center(
                    child: PrimaryText(
                      text: 'No service details available',
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServiceDetailsHeader(service: controller.service.value!),

                      SizedBox(height: 12),

                      // Title
                      Center(
                        child: PrimaryText(
                          text: service.title ?? '',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          textColor: context.resources.color.colorGrey,
                        ),
                      ),

                      // Category
                      if (service.categoryName != null)
                        Center(
                          child: PrimaryText(
                            text: service.parentCategoryName != null
                                ? "${service.parentCategoryName} / ${service.categoryName}"
                                : service.categoryName.toString(),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            textColor: context.resources.color.colorGrey,
                          ),
                        ),

                      SizedBox(height: 20),

                      // Price Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: '0',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: 'Completed Jobs',
                                  fontSize: 14,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 1.5,
                            height: 30,
                            color: context.resources.color.colorGrey,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: '\$${service.unitPrice}',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: 'Hourly Rate',
                                  fontSize: 14,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Container(
                        width: double.infinity,
                        height: 1,
                        color: context.resources.color.colorGrey.withOpacity(
                          .25,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: 'Work Experience',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 4),

                            PrimaryText(
                              text: service.experience ?? "N/A",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        height: 1,
                        color: context.resources.color.colorGrey.withOpacity(
                          .25,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Skills
                            if (service.skills != null &&
                                service.skills!.isNotEmpty) ...[
                              PrimaryText(
                                text: 'Skills',
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                textColor: context.resources.color.colorGrey,
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: service.skills!.map((skill) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color:
                                            context.resources.color.colorGrey4,
                                      ),
                                    ),
                                    child: PrimaryText(
                                      text: skill.name ?? '',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      textColor:
                                          context.resources.color.colorGrey,
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 24),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
