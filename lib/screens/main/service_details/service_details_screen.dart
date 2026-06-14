import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/working_hours_widget.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/service_details/service_details_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/auth_guard.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/primary_network_image.dart';
import '../../../components/progress_bar.dart';
import '../../../model/LoginResponse.dart';
import '../../../utils/res/AppIcons.dart';
import '../../../utils/utils.dart';
import 'components/service_packages_carousel.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceDetailsController());

    final unitPrice = controller.service.value!.pricingType.toString() == 'U'
        ? controller.service.value?.unitPrice
        : controller.service.value?.totalPrice;

    final priceTitle = controller.service.value!.pricingType.toString() == 'U'
        ? context.resources.strings.hourlyRate
        : context.resources.strings.totalPrice;

    return Scaffold(
      backgroundColor: context.resources.color.background2,
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

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: context.resources.color.colorWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: Utils().isRTL() ? 2 : 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Image.asset(
                                              AppIcons.back3,
                                              width: 38,
                                            ),
                                          ),
                                        ),
                                        Spacer(),

                                        if (controller
                                                .service
                                                .value
                                                ?.memberHashcode !=
                                            Prefs.getId)
                                          Obx(
                                            () => GestureDetector(
                                              onTap:
                                                  controller
                                                      .isFavoriteLoading
                                                      .value
                                                  ? null
                                                  : controller.toggleFavorite,
                                              child:
                                                  controller
                                                      .isFavoriteLoading
                                                      .value
                                                  ? SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: ProgressBar(),
                                                    )
                                                  : Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: context
                                                              .resources
                                                              .color
                                                              .colorGrey15,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Image.asset(
                                                          controller
                                                                  .isFavorite
                                                                  .value
                                                              ? AppIcons
                                                                    .banomarkOn
                                                              : AppIcons
                                                                    .banomark,
                                                          width: 18,
                                                          color: context
                                                              .resources
                                                              .color
                                                              .colorPrimary,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // ServiceDetailsHeader(),
                                  SizedBox(height: 12),

                                  // Title
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: PrimaryText(
                                      text: service.title ?? '',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      textColor:
                                          context.resources.color.colorBlack,
                                    ),
                                  ),

                                  // Category
                                  if (service.categoryName != null)
                                    SizedBox(height: 2),
                                  if (service.categoryName != null)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: PrimaryText(
                                        text: service.parentCategoryName != null
                                            ? "${service.parentCategoryName} / ${service.categoryName}"
                                            : service.categoryName.toString(),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        textColor:
                                            context.resources.color.colorGrey,
                                      ),
                                    ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),

                            SizedBox(height: 16),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          RouteConstant
                                              .employerMemberProfileScreen,
                                          arguments: User(
                                            hashcode: controller
                                                .service
                                                .value
                                                ?.memberHashcode
                                                .toString(),
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
                                              .resources
                                              .color
                                              .colorWhite,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: context
                                                .resources
                                                .color
                                                .colorPrimary,
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
                                                  color: context
                                                      .resources
                                                      .color
                                                      .colorPrimary,
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: PrimaryNetworkImage(
                                                  url:
                                                      controller
                                                          .service
                                                          .value
                                                          ?.memberImage
                                                          .toString() ??
                                                      '',
                                                  width: 35,
                                                  height: 35,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            Flexible(
                                              child: PrimaryText(
                                                text:
                                                    '${controller.service.value?.memberFirstName.toString() ?? ''}\n ${controller.service.value?.memberLastName.toString() ?? ''}',
                                                fontSize: 12,
                                                maxLines: 2,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Image.asset(
                                              AppIcons.star2,
                                              width: 12,
                                            ),
                                            SizedBox(width: 2),
                                            PrimaryText(
                                              text:
                                                  controller
                                                      .service
                                                      .value
                                                      ?.memberRating
                                                      .toString() ??
                                                  'N/A',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
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
                                          .resources
                                          .color
                                          .colorPrimaryLight,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: PrimaryText(
                                      text: '$priceTitle: \$$unitPrice',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      maxLines: 2,
                                      textColor:
                                          context.resources.color.colorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16),

                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.all(12),
                              decoration: _cardDecoration,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (service.description.toString().isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PrimaryText(
                                          text: context
                                              .resources
                                              .strings
                                              .overview,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorBlack4,
                                        ),

                                        SizedBox(height: 4),

                                        PrimaryText(
                                          text:
                                              service.description ??
                                              context
                                                  .resources
                                                  .strings
                                                  .notAvailable,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                      ],
                                    ),

                                  if (service.experience.toString().isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 16),

                                        PrimaryText(
                                          text: context
                                              .resources
                                              .strings
                                              .workExperience,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorBlack4,
                                        ),

                                        SizedBox(height: 4),

                                        PrimaryText(
                                          text:
                                              service.experience ??
                                              context
                                                  .resources
                                                  .strings
                                                  .notAvailable,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Skills
                                  if (service.skills != null &&
                                      service.skills!.isNotEmpty) ...[
                                    SizedBox(height: 16),
                                    Container(

                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      padding: EdgeInsets.all(12),
                                      decoration: _cardDecoration,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [

                                          PrimaryText(
                                            text: context
                                                .resources
                                                .strings
                                                .skills,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorBlack4,
                                          ),
                                          SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: service.skills!.map((
                                              skill,
                                            ) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: context
                                                      .resources
                                                      .color
                                                      .colorPrimaryLight,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                child: PrimaryText(
                                                  text: skill.name ?? '',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  textColor: context
                                                      .resources
                                                      .color
                                                      .colorPrimary,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  // Covered Areas
                                  if (service.areas != null &&
                                      service.areas!.isNotEmpty) ...[
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      padding: EdgeInsets.all(12),
                                      decoration: _cardDecoration,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 16),

                                          PrimaryText(
                                            text: context
                                                .resources
                                                .strings
                                                .areasYouCover,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorBlack4,
                                          ),
                                          SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: service.areas!.map((
                                              area,
                                            ) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  border: Border.all(
                                                    color: context
                                                        .resources
                                                        .color
                                                        .colorGrey4,
                                                  ),
                                                ),
                                                child: PrimaryText(
                                                  text: area.name ?? '',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  textColor: context
                                                      .resources
                                                      .color
                                                      .colorGrey,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Working Hours
                            if (service.availability != null &&
                                service.availability!.isNotEmpty) ...[
                              SizedBox(height: 16),
                              WorkingHoursWidget(
                                availability: service.availability!,
                              ),
                            ],
                            SizedBox(height: 16),

                            // Packages Section
                            ServicePackagesCarousel(
                              packages: service.packages ?? [],
                              onBookPackage: (package) {
                                if (!requireLogin()) return;
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

                    if (service.memberHashcode.toString() != Prefs.getId)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: PrimaryButton(
                          title: context.resources.strings.bookNow,
                          onPressed: () {
                            if (!requireLogin()) return;
                            Get.toNamed(
                              RouteConstant.bookServiceScreen,
                              arguments: service,
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
