import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/package_details/components/package_details_header.dart';
import 'package:wazafak_app/screens/main/package_details/package_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class PackageDetailsScreen extends StatelessWidget {
  const PackageDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PackageDetailsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final package = controller.package.value;
                if (package == null) {
                  return Center(
                    child: PrimaryText(
                      text: 'No package details available',
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PackageDetailsHeader(package: controller.package.value!),

                      SizedBox(height: 12),

                      // Title
                      Center(
                        child: PrimaryText(
                          text: package.title ?? '',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          textColor: context.resources.color.colorGrey,
                        ),
                      ),

                      SizedBox(height: 20),

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
                              text: 'Pack Details',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 4),

                            PrimaryText(
                              text: package.description ?? "N/A",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 16),
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
