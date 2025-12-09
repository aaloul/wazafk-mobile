import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/outlined_button.dart';
import '../../../components/top_header.dart';
import '../../../utils/Prefs.dart';
import 'components/change_request_bottom_sheet.dart';
import 'components/dispute_bottom_sheet.dart';
import 'components/finish_engagement_bottom_sheet.dart';
import 'components/negotiation_bottom_sheet.dart';

class EngagementDetailsScreen extends StatelessWidget {
  const EngagementDetailsScreen({super.key});

  String _getWorkLocationTypeName(String? code) {
    switch (code) {
      case 'RMT':
        return 'Remote';
      case 'HYB':
        return 'Hybrid';
      case 'SIT':
        return 'Onsite';
      default:
        return code ?? 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EngagementDetailsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Engagement'),
            SizedBox(height: 16),

            Obx(() {
              if (controller.isLoading.value) {
                return Expanded(
                  child: Center(
                    child: ProgressBar(
                      color: context.resources.color.colorPrimary,
                    ),
                  ),
                );
              }

                final engagement = controller.engagement.value;
                if (engagement == null) {
                  return Expanded(
                      child: Center(
                    child: PrimaryText(
                      text: 'No engagement details available',
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                      ));
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() {
                            if (controller.service.value == null &&
                                controller.package.value == null &&
                                controller.job.value == null) {
                              return Center(child: ProgressBar());
                            }

                            // Get data from service, package, or job
                            final title = controller.isJob.value
                                ? controller.job.value!.title
                                : controller.isPackage.value
                                ? controller.package.value!.title
                                : controller.service.value!.title;
                            final unitPrice = controller.engagement.value
                                ?.unitPrice ?? 'N/A';
                            final memberFirstName = controller.isJob.value
                                ? controller.job.value!.memberFirstName
                                : controller.isPackage.value
                                ? controller.package.value!.memberFirstName
                                : controller.service.value!.memberFirstName;
                            final memberLastName = controller.isJob.value
                                ? controller.job.value!.memberLastName
                                : controller.isPackage.value
                                ? controller.package.value!.memberLastName
                                : controller.service.value!.memberLastName;
                            final memberImage = controller.isJob.value
                                ? controller.job.value!.memberImage
                                : controller.isPackage.value
                                ? controller.package.value!.memberImage
                                : controller.service.value!.memberImage;
                            final memberRating = controller.isJob.value
                                ? controller.job.value!.memberRating
                                : controller.isPackage.value
                                ? controller.package.value!.memberRating
                                : controller.service.value!.memberRating;
                            final categoryName = controller.isJob.value
                                ? controller.job.value!.categoryName
                                : controller.isPackage.value
                                ? (controller.package.value!.services !=
                                null &&
                                controller
                                    .package
                                    .value!
                                    .services!
                                    .isNotEmpty
                                ? controller
                                .package
                                .value!
                                .services!
                                .first
                                .categoryName
                                : 'Package')
                                : controller.service.value!.categoryName;
                            final parentCategoryName = controller.isJob.value
                                ? controller.job.value!.parentCategoryName
                                : controller.isPackage.value
                                ? (controller.package.value!.services !=
                                null &&
                                controller
                                    .package
                                    .value!
                                    .services!
                                    .isNotEmpty
                                ? controller
                                .package
                                .value!
                                .services!
                                .first
                                .parentCategoryName
                                : null)
                                : controller
                                .service
                                .value!
                                .parentCategoryName;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: context.resources.color.colorBlue4,
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            PrimaryText(
                                              text: title ?? '',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey,
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              children: [
                                                if (parentCategoryName !=
                                                    null)
                                                  Expanded(
                                                    child: PrimaryText(
                                                      text:
                                                      "$parentCategoryName/$categoryName",
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      textColor: context
                                                          .resources
                                                          .color
                                                          .colorGrey,
                                                    ),
                                                  ),
                                                if (parentCategoryName ==
                                                    null)
                                                PrimaryText(
                                                  text: categoryName ?? '',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  textColor: context
                                                      .resources
                                                      .color
                                                      .colorGrey,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          PrimaryText(
                                            text: '\$$unitPrice',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey,
                                          ),
                                          SizedBox(height: 2),
                                          PrimaryText(
                                            text: 'Hourly Rate',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  color: context.resources.color.colorBlue4,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          99999,
                                        ),
                                        child: PrimaryNetworkImage(
                                          url: memberImage.toString(),
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),

                                      SizedBox(width: 8),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            PrimaryText(
                                              text:
                                              "$memberFirstName $memberLastName",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey,
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  AppIcons.star2,
                                                  width: 14,
                                                ),
                                                SizedBox(width: 2),
                                                PrimaryText(
                                                  text: memberRating
                                                      .toString(),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  textColor: context
                                                      .resources
                                                      .color
                                                      .colorGrey,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),

                        SizedBox(height: 20),

                        // Main Details
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Skills for Service Booking
                              if (engagement.type.toString() == 'SB' &&
                                  engagement.services != null &&
                                  engagement.services!.isNotEmpty &&
                                  engagement.services!.first.skills != null &&
                                  engagement
                                      .services!
                                      .first
                                      .skills!
                                      .isNotEmpty) ...[
                                PrimaryText(
                                  text: 'Skills',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: engagement.services!.first.skills!
                                      .map((skill) {
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
                                        text: skill.name ?? '',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        textColor: context
                                            .resources
                                            .color
                                            .colorGrey,
                                      ),
                                    );
                                  })
                                      .toList(),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: context.resources.color.colorGrey
                                      .withOpacity(.25),
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ],

                              // Skills for Job Application
                              if (engagement.type.toString() == 'JA' &&
                                  engagement.job != null &&
                                  engagement.job!.skills != null &&
                                  engagement.job!.skills!.isNotEmpty) ...[
                                PrimaryText(
                                  text: 'Skills',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: engagement.job!.skills!.map((
                                      skill,) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          24,
                                        ),
                                        border: Border.all(
                                          color: context
                                              .resources
                                              .color
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
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: context.resources.color.colorGrey
                                      .withOpacity(.25),
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ],

                              // Services for Package Booking
                              if (engagement.type.toString() == 'PB' &&
                                  engagement.package != null &&
                                  engagement.package!.services != null &&
                                  engagement
                                      .package!
                                      .services!
                                      .isNotEmpty) ...[
                                PrimaryText(
                                  text: 'Services',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: engagement.package!.services!.map(
                                        (service) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          border: Border.all(
                                            color: context
                                                .resources
                                                .color
                                                .colorGrey4,
                                          ),
                                        ),
                                        child: PrimaryText(
                                          text: service.title ?? '',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorGrey,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: context.resources.color.colorGrey
                                      .withOpacity(.25),
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ],

                              // Work Location
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppIcons.location,
                                    width: 20,
                                    color: context.resources.color.colorGrey,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        if (engagement.workLocationType
                                            .toString()
                                            .isNotEmpty)
                                          PrimaryText(
                                            text: _getWorkLocationTypeName(
                                              engagement.workLocationType,
                                            ),
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey,
                                          ),
                                        // Show full address if not Remote
                                        if (engagement.workLocationType
                                            ?.toString() !=
                                            'RMT' &&
                                            engagement.address != null) ...[
                                          if (engagement.address!.city !=
                                              null)
                                            PrimaryText(
                                              text:
                                              engagement.address!.city ??
                                                  '',
                                              fontSize: 13,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey19,
                                            ),
                                          if (engagement.address!.street !=
                                              null)
                                            PrimaryText(
                                              text:
                                              engagement
                                                  .address!
                                                  .street ??
                                                  '',
                                              fontSize: 13,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey19,
                                            ),
                                          if (engagement.address!.building !=
                                              null ||
                                              engagement.address!.apartment !=
                                                  null)
                                            PrimaryText(
                                              text:
                                              '${engagement.address!.building ??
                                                  ''} ${engagement.address!
                                                  .apartment ?? ''}'
                                                  .trim(),
                                              fontSize: 13,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey19,
                                            ),
                                          if (engagement.address!.address !=
                                              null)
                                            PrimaryText(
                                              text:
                                              engagement
                                                  .address!
                                                  .address ??
                                                  '',
                                              fontSize: 13,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey19,
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8),

                              // Start Date
                              if (engagement.startDatetime != null)
                                Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.calendar,
                                      width: 20,
                                      color:
                                      context.resources.color.colorGrey,
                                    ),
                                    SizedBox(width: 6),
                                    PrimaryText(
                                      text:
                                      'Start: ${DateFormat(
                                          'MMM dd, yyyy - hh:mm a')
                                          .format(engagement.startDatetime!)}',
                                      textColor:
                                      context.resources.color.colorGrey,
                                    ),
                                  ],
                                ),

                              SizedBox(height: 8),

                              // Expiry Date
                              if (engagement.expiryDatetime != null)
                                Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.calendar,
                                      width: 20,
                                      color:
                                      context.resources.color.colorGrey,
                                    ),
                                    SizedBox(width: 6),
                                    PrimaryText(
                                      text:
                                      'Due: ${DateFormat(
                                          'MMM dd, yyyy - hh:mm a').format(
                                          engagement.expiryDatetime!)}',
                                      textColor:
                                      context.resources.color.colorGrey,
                                    ),
                                  ],
                                ),

                              SizedBox(height: 8),

                              // Estimated Hours
                              if (engagement.estimatedHours != null)
                                Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.clock,
                                      width: 20,
                                      color:
                                      context.resources.color.colorGrey,
                                    ),
                                    SizedBox(width: 6),
                                    PrimaryText(
                                      text:
                                      'Estimated Hours: ${engagement
                                          .estimatedHours}',
                                      textColor:
                                      context.resources.color.colorGrey,
                                    ),
                                  ],
                                ),

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

                              if (engagement.description != null &&
                                  engagement.description
                                      .toString()
                                      .isNotEmpty) ...[
                                // Description
                                PrimaryText(
                                  text: 'Description',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: engagement.description ?? "N/A",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),

                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: context.resources.color.colorGrey
                                      .withOpacity(.25),
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ],

                              // Tasks & Milestones
                              if (engagement.tasksMilestones != null &&
                                  engagement.tasksMilestones
                                      .toString()
                                      .isNotEmpty) ...[
                                PrimaryText(
                                  text: 'Milestones',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: engagement.tasksMilestones ?? "N/A",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),

                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: context.resources.color.colorGrey
                                      .withOpacity(.25),
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ],

                              // Message to Client (for Service/Package bookings)
                              if ((engagement.type.toString() == 'SB' ||
                                  engagement.type.toString() == 'PB') &&
                                  engagement.messageToClient != null &&
                                  engagement.messageToClient
                                      .toString()
                                      .isNotEmpty) ...[
                                PrimaryText(
                                  text: 'Message to Client',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: engagement.messageToClient ?? "N/A",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 16),
                              ],

                              // Message to Freelancer (for Job applications)
                              if (engagement.type.toString() == 'JA' &&
                                  engagement.messageToFreelancer != null &&
                                  engagement.messageToFreelancer
                                      .toString()
                                      .isNotEmpty) ...[
                                PrimaryText(
                                  text: 'Message to Freelancer',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text:
                                  engagement.messageToFreelancer ?? "N/A",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textColor:
                                  context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
            }),


            // Accept/Reject buttons when status is 0 (pending)
            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == 0) {
                // Check if there's a pending change request
                if (engagement?.pendingChangeRequest == 1) {
                  // Check if current user is the requester
                  final currentUserId = Prefs.getId;
                  final changeRequests = engagement?.changeRequests;
                  final isRequester = changeRequests != null &&
                      changeRequests.isNotEmpty &&
                      changeRequests.first.requesterHashcode == currentUserId;

                  if (isRequester) {
                    // Show waiting for reply message
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.resources.color.colorWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorBlue4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              color: context.resources.color.colorPrimary,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: 'Waiting for Reply',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor: context.resources.color
                                        .colorGrey,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: 'Your change request is pending approval',
                                    fontSize: 14,
                                    textColor: context.resources.color
                                        .colorGrey7,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Show View Changes button
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.resources.color.colorWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: PrimaryButton(
                        title: 'View Changes',
                        onPressed: () {
                          Get.bottomSheet(
                            ChangeRequestBottomSheet(),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                      ),
                    );
                  }
                } else {
                  // Determine if user can accept/reject based on engagement type
                  final currentUserId = Prefs.getId;
                  final engagementType = engagement?.type;
                  bool canAcceptReject = false;

                  if (engagementType == 'JA') {
                    // Job Application: Client can accept/reject
                    canAcceptReject =
                        currentUserId == engagement?.clientHashcode;
                  } else if (engagementType == 'SB' || engagementType == 'PB') {
                    // Service/Package Booking: Freelancer can accept/reject
                    canAcceptReject =
                        currentUserId == engagement?.freelancerHashcode;
                  }

                  if (canAcceptReject) {
                    // Check if there are any change requests
                    final hasChangeRequests = engagement?.changeRequests !=
                        null &&
                        engagement!.changeRequests!.isNotEmpty;

                    // Show Accept Request, Decline, and Negotiate buttons
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.resources.color.colorWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Obx(() {
                            if (controller.isAccepting.value) {
                              return Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorPrimary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: context.resources.color.colorWhite,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return PrimaryButton(
                              title: 'Accept Request',
                              onPressed: controller.acceptEngagement,
                            );
                          }),

                          SizedBox(height: 12),

                          Obx(() {
                            if (controller.isRejecting.value) {
                              return Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorRed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: context.resources.color.colorWhite,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return PrimaryOutlinedButton(
                              title: 'Decline',
                              onPressed: controller.rejectEngagement,
                            );
                          }),

                          // Only show Negotiate button if there are no change requests
                          if (!hasChangeRequests) ...[
                            SizedBox(height: 12),
                            PrimaryOutlinedButton(
                              title: 'Negotiate',
                              onPressed: () {
                                Get.bottomSheet(
                                  NegotiationBottomSheet(),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    );
                  } else {
                    // Show waiting for reply message
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.resources.color.colorWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorBlue4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              color: context.resources.color.colorPrimary,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: 'Waiting for Reply',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor: context.resources.color
                                        .colorGrey,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: 'Your engagement request is pending approval',
                                    fontSize: 14,
                                    textColor: context.resources.color
                                        .colorGrey7,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              }
              return SizedBox.shrink();
            }),

            // Finish Engagement button when status is 1 (accepted)
            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == 1) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if(Prefs.getId ==
                          engagement?.freelancerHashcode.toString() &&
                          engagement?.hasDispute.toString() == '0')
                        PrimaryButton(
                          title: 'Finish Engagement',
                          onPressed: () {
                            Get.bottomSheet(
                              FinishEngagementBottomSheet(),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                        ),
                      if(Prefs.getId ==
                          engagement?.freelancerHashcode.toString())
                        SizedBox(height: 12),

                      PrimaryOutlinedButton(
                        title: 'Submit Dispute',
                        onPressed: () {
                          Get.bottomSheet(
                            DisputeBottomSheet(),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),

            // Accept/Reject Finish Engagement buttons when status is 4
            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == 4 &&
                  Prefs.getId == engagement?.clientHashcode.toString()) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                        if (controller.isAcceptingFinishEngagement.value) {
                          return Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: context.resources.color.colorPrimary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: context.resources.color.colorWhite,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        }

                        return PrimaryButton(
                          title: 'Accept Finish',
                          onPressed: controller.acceptFinishEngagement,
                        );
                      }),

                      SizedBox(height: 12),

                      Obx(() {
                        if (controller.isRejectingFinishEngagement.value) {
                          return Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: context.resources.color.colorRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: context.resources.color.colorWhite,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        }

                        return PrimaryOutlinedButton(
                          title: 'Reject Finish',
                          onPressed: controller.rejectFinishEngagement,
                        );
                      }),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),

            // Submit Dispute button when status is -3
            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == -3) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      PrimaryButton(
                        title: 'Submit Dispute',
                        onPressed: () {
                          Get.bottomSheet(
                            DisputeBottomSheet(),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
