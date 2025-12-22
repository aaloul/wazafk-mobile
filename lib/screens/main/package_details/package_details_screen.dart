import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/package_details/components/package_details_header.dart';
import 'package:wazafak_app/screens/main/package_details/package_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/primary_button.dart';
import '../../../constants/route_constant.dart';
import '../../../utils/Prefs.dart';

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
                      text: context.resources.strings.noPackageDetailsAvailable,
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                return Column(
                  children: [

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PackageDetailsHeader(),

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
                            SizedBox(height: 6),
                            // Price
                            Center(
                              child: PrimaryText(
                                text: '\$${package.totalPrice}',
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                textColor: context.resources.color.colorGrey3,
                              ),
                            ),


                            Container(
                              width: double.infinity,
                              height: 1,
                              color: context.resources.color.colorGrey
                                  .withOpacity(
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
                                    text: context.resources.strings.packDetails,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    textColor: context.resources.color
                                        .colorGrey,
                                  ),

                                  SizedBox(height: 4),

                                  PrimaryText(
                                    text: package.description ??
                                        context.resources.strings.notAvailable,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textColor: context.resources.color
                                        .colorGrey,
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: context.resources.color.colorGrey
                                  .withOpacity(
                                .25,
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 16),

                    if(package.memberHashcode.toString() != Prefs.getId)
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: PrimaryButton(
                        title: context.resources.strings.bookPackage,
                        onPressed: () {
                          Get.toNamed(
                            RouteConstant.bookServiceScreen,
                            arguments: package,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16),


                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
