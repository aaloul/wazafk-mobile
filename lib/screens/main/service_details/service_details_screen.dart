import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/service_details/components/service_details_header.dart';
import 'package:wazafak_app/screens/main/service_details/service_details_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/service_packages_carousel.dart';

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
                      text: context.resources.strings.noServiceDetailsAvailable,
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                return
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ServiceDetailsHeader(),

                              SizedBox(height: 12),

                              // Title
                              Center(
                                child: PrimaryText(
                                  text: service.title ?? '',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ),

                              // Category
                              if (service.categoryName != null)
                                Center(
                                  child: PrimaryText(
                                    text: service.parentCategoryName != null
                                        ? "${service
                                        .parentCategoryName} / ${service
                                        .categoryName}"
                                        : service.categoryName.toString(),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textColor: context.resources.color
                                        .colorGrey,
                                  ),
                                ),

                              SizedBox(height: 20),

                              // Price Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        PrimaryText(
                                          text: '0',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          textColor: context.resources.color
                                              .colorGrey,
                                        ),
                                        SizedBox(height: 4),
                                        PrimaryText(
                                          text: context.resources.strings
                                              .completedJobs,
                                          fontSize: 14,
                                          textColor: context.resources.color
                                              .colorGrey,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: 1.5,
                                    height: 30,
                                    color: context.resources.color.colorGrey,
                                  ),

                                 service.pricingType.toString() == 'U'
                                      ?    Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        PrimaryText(
                                          text: '\$${service.unitPrice}',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          textColor: context.resources.color
                                              .colorGrey,
                                        ),
                                        SizedBox(height: 4),
                                        PrimaryText(
                                          text: context.resources.strings
                                              .hourlyRate,
                                          fontSize: 14,
                                          textColor: context.resources.color
                                              .colorGrey,
                                        ),
                                      ],
                                    ),
                                  ) :
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment
                                         .center,
                                     children: [
                                       PrimaryText(
                                         text: '\$${service.totalPrice}',
                                         fontSize: 18,
                                         fontWeight: FontWeight.w900,
                                         textColor: context.resources.color
                                             .colorGrey,
                                       ),
                                       SizedBox(height: 4),
                                       PrimaryText(
                                         text: context.resources.strings
                                             .totalPrice,
                                         fontSize: 14,
                                         textColor: context.resources.color
                                             .colorGrey,
                                       ),
                                     ],
                                   ),
                                 )
                                  ,
                                ],
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
                                      text: context.resources.strings
                                          .workExperience,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      textColor: context.resources.color
                                          .colorGrey,
                                    ),

                                    SizedBox(height: 4),

                                    PrimaryText(
                                      text: service.experience ??
                                          context.resources.strings
                                              .notAvailable,
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

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Skills
                                    if (service.skills != null &&
                                        service.skills!.isNotEmpty) ...[
                                      PrimaryText(
                                        text: context.resources.strings.skills,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        textColor: context.resources.color
                                            .colorGrey,
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
                                              borderRadius: BorderRadius
                                                  .circular(24),
                                              border: Border.all(
                                                color:
                                                context.resources.color
                                                    .colorGrey4,
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
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: context.resources.color.colorGrey
                                            .withOpacity(.25),
                                        margin: EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 8,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Packages Section
                              ServicePackagesCarousel(
                                packages: service.packages ?? [],
                                onBookPackage: (package) {
                                  Get.toNamed(
                                    RouteConstant.bookServiceScreen,
                                    arguments: package,
                                  );
                                },
                              ),


                                SizedBox(height: 16),



                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      if(service.memberHashcode.toString() != Prefs.getId)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: PrimaryButton(
                          title: context.resources.strings.bookNow,
                          onPressed: () {
                            Get.toNamed(
                              RouteConstant.bookServiceScreen,
                              arguments: service,
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 16),
                    ],
                  )
                ;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
