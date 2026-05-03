import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/working_hours_widget.dart';
import 'package:wazafak_app/screens/main/package_details/components/package_details_header.dart';
import 'package:wazafak_app/screens/main/package_details/package_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/primary_button.dart';
import '../../../components/primary_network_image.dart';
import '../../../constants/route_constant.dart';
import '../../../model/LoginResponse.dart';
import '../../../utils/Prefs.dart';
import '../../../utils/res/AppIcons.dart';

class PackageDetailsScreen extends StatelessWidget {
  const PackageDetailsScreen({super.key});

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PackageDetailsController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
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

                            SizedBox(height: 16),

                            // Profile + Price row
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                        RouteConstant
                                            .employerMemberProfileScreen,
                                        arguments: User(
                                          hashcode: package.memberHashcode
                                              ?.toString(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context
                                            .resources.color.colorWhite,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: context
                                              .resources.color.colorPrimary,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: context.resources.color
                                                    .colorPrimary,
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: PrimaryNetworkImage(
                                                url: package.memberImage
                                                        ?.toString() ??
                                                    '',
                                                width: 35,
                                                height: 35,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          PrimaryText(
                                            text:
                                                '${package.memberFirstName ?? ''}\n ${package.memberLastName ?? ''}',
                                            fontSize: 12,
                                            maxLines: 2,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(width: 4),
                                          Image.asset(
                                            AppIcons.star2,
                                            width: 12,
                                          ),
                                          SizedBox(width: 2),
                                          PrimaryText(
                                            text: package.memberRating
                                                    ?.toString() ??
                                                'N/A',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context
                                          .resources.color.colorPrimaryLight,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: PrimaryText(
                                      text:
                                          '${context.resources.strings.totalPrice}: \$${package.totalPrice}',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      maxLines: 2,
                                      textColor: context
                                          .resources.color.colorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16),

                            // Description card
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.all(12),
                              decoration: _cardDecoration,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context
                                        .resources.strings.packDetails,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        context.resources.color.colorBlack4,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: package.description ??
                                        context
                                            .resources.strings.notAvailable,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                ],
                              ),
                            ),

                            // Working Hours
                            if (package.availability != null &&
                                package.availability!.isNotEmpty) ...[
                              SizedBox(height: 16),
                              WorkingHoursWidget(
                                availability: package.availability!,
                              ),
                            ],

                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    if (package.memberHashcode.toString() != Prefs.getId)
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
