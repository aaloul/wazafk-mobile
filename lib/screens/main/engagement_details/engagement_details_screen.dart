import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../components/outlined_button.dart';
import '../../../constants/route_constant.dart';
import '../../../utils/Prefs.dart';
import 'components/change_request_bottom_sheet.dart';
import 'components/dispute_bottom_sheet.dart';
import 'components/negotiation_bottom_sheet.dart';
import 'components/verify_face_match_bottom_sheet.dart';

class EngagementDetailsScreen extends StatelessWidget {
  const EngagementDetailsScreen({super.key});

  String _getWorkLocationTypeName(BuildContext context, String? code) {
    switch (code) {
      case 'RMT':
        return context.resources.strings.remote;
      case 'HYB':
        return context.resources.strings.hybrid;
      case 'SIT':
        return context.resources.strings.onsite;
      default:
        return context.resources.strings.notAvailable;
    }
  }

  bool _isImageFile(String url) {
    final extension = url.toLowerCase().split('.').last.split('?').first;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  Future<void> _openFileInBrowser(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Resources.of(context).strings.couldNotLaunchUrl(url);
    }
  }

  void _showExpandedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: PrimaryNetworkImage(
                    url: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const PrimaryText(
                      text: '✕',
                      textColor: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EngagementDetailsController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return Expanded(
                  child: Column(
                    children: [
                      _buildBackButton(context),
                      Expanded(
                        child: Center(
                          child: ProgressBar(
                            color: context.resources.color.colorPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final engagement = controller.engagement.value;
              if (engagement == null) {
                return Expanded(
                  child: Column(
                    children: [
                      _buildBackButton(context),
                      Expanded(
                        child: Center(
                          child: PrimaryText(
                            text: context
                                .resources
                                .strings
                                .noTaskDetailsAvailable,
                            fontSize: 14,
                            textColor: context.resources.color.colorGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final unitPrice = controller.isPackage.value
                  ? controller.engagement.value?.totalPrice
                  : controller.isService.value
                  ? controller.service.value!.pricingType.toString() == 'U'
                        ? controller.engagement.value?.unitPrice
                        : controller.engagement.value?.totalPrice
                  : controller.isJob.value
                  ? controller.engagement.value?.totalPrice
                  : controller.engagement.value?.unitPrice ?? 'N/A';

              final priceTitle = controller.isJob.value
                  ? context.resources.strings.totalPrice
                  : controller.isPackage.value
                  ? context.resources.strings.totalPrice
                  : controller.service.value!.pricingType.toString() == 'U'
                  ? context.resources.strings.hourlyRate
                  : context.resources.strings.totalPrice;

              final memberFirstName =
                  engagement.clientHashcode.toString() == Prefs.getId
                  ? "${engagement.freelancerFirstName}"
                  : "${engagement.clientFirstName}";
              final memberLastName =
                  engagement.clientHashcode.toString() == Prefs.getId
                  ? "${engagement.freelancerLastName}"
                  : "${engagement.clientLastName}";
              final memberImage =
                  engagement.clientHashcode.toString() == Prefs.getId
                  ? engagement.freelancerImage.toString()
                  : engagement.clientImage.toString();
              final memberRating =
                  engagement.clientHashcode.toString() == Prefs.getId
                  ? engagement.freelancerRating ?? '0'
                  : engagement.clientRating ?? '0';

              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header card ──────────────────────────────────────
                      Obx(() {
                        if (controller.service.value == null &&
                            controller.package.value == null &&
                            controller.job.value == null) {
                          return Container(
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
                              children: [
                                _buildBackButton(context, statusLabel: engagement.statusLabel?.toString(), statusColor: engagement.statusColor?.toString()),
                                Center(child: ProgressBar()),
                                SizedBox(height: 16),
                              ],
                            ),
                          );
                        }

                        final title = controller.isJob.value
                            ? controller.job.value!.title
                            : controller.isPackage.value
                            ? controller.package.value!.title
                            : controller.service.value!.title;

                        final categoryName = controller.isJob.value
                            ? controller.job.value!.categoryName
                            : controller.isPackage.value
                            ? (controller.package.value!.services != null &&
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
                                  : context.resources.strings.package)
                            : controller.service.value!.categoryName;

                        final parentCategoryName = controller.isJob.value
                            ? controller.job.value!.parentCategoryName
                            : controller.isPackage.value
                            ? (controller.package.value!.services != null &&
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
                            : controller.service.value!.parentCategoryName;

                        return Container(
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
                              _buildBackButton(context, statusLabel: engagement.statusLabel?.toString(), statusColor: engagement.statusColor?.toString()),
                              SizedBox(height: 4),

                              // Title + price
                              GestureDetector(
                                onTap: () {
                                  if (controller.isJob.value &&
                                      controller.job.value != null) {
                                    Get.toNamed(
                                      RouteConstant.jobDetailsScreen,
                                      arguments: controller.job.value,
                                    );
                                  } else if (controller.isService.value &&
                                      controller.service.value != null) {
                                    Get.toNamed(
                                      RouteConstant.serviceDetailsScreen,
                                      arguments: controller.service.value,
                                    );
                                  } else if (controller.isPackage.value &&
                                      controller.package.value != null) {
                                    Get.toNamed(
                                      RouteConstant.packageDetailsScreen,
                                      arguments: controller.package.value,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            PrimaryText(
                                              text: title ?? '',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorBlack,
                                            ),
                                            SizedBox(height: 4),
                                            PrimaryText(
                                              text: parentCategoryName != null
                                                  ? '$parentCategoryName / $categoryName'
                                                  : categoryName ?? '',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 16),
                                  Image.asset(
                                    AppIcons.location,
                                    width: 12,
                                    color: context.resources.color.colorGrey,
                                  ),
                                  SizedBox(width: 4),
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
                                              context,
                                              engagement.workLocationType,
                                            ),
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey29,
                                          ),
                                        if (engagement.workLocationType
                                                    ?.toString() !=
                                                'RMT' &&
                                            engagement.address != null) ...[
                                          if (engagement.address!.city != null)
                                            PrimaryText(
                                              text:
                                                  engagement.address!.city ??
                                                  '',
                                              fontSize: 13,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey29,
                                            ),
                                          if (engagement.address!.street !=
                                              null)
                                            PrimaryText(
                                              text:
                                                  engagement.address!.street ??
                                                  '',
                                              fontSize: 13,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey29,
                                            ),
                                          if (engagement.address!.building !=
                                                  null ||
                                              engagement.address!.apartment !=
                                                  null)
                                            PrimaryText(
                                              text:
                                                  '${engagement.address!.building ?? ''} ${engagement.address!.apartment ?? ''}'
                                                      .trim(),
                                              fontSize: 13,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey29,
                                            ),
                                          if (engagement.address!.address !=
                                              null)
                                            PrimaryText(
                                              text:
                                                  engagement.address!.address ??
                                                  '',
                                              fontSize: 13,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey29,
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8),

                              Row(
                                children: [
                                  if (engagement.startDatetime != null) ...[
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            AppIcons.calendar,
                                            width: 14,
                                            color: context
                                                .resources
                                                .color
                                                .colorGrey26,
                                          ),
                                          SizedBox(width: 4),
                                          PrimaryText(
                                            text:
                                                '${context.resources.strings.start}: ${DateFormat('MMM dd, yyyy').format(engagement.startDatetime!)}',
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey29,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (engagement.expiryDatetime != null) ...[
                                    Row(
                                      children: [
                                        SizedBox(width: 16),

                                        Image.asset(
                                          AppIcons.calendar,
                                          width: 14,
                                          color: context
                                              .resources
                                              .color
                                              .colorGrey26,
                                        ),
                                        SizedBox(width: 4),
                                        PrimaryText(
                                          text:
                                              '${context.resources.strings.due}: ${DateFormat('MMM dd, yyyy').format(engagement.expiryDatetime!)}',
                                          textColor: context
                                              .resources
                                              .color
                                              .colorGrey29,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(width: 16),
                                      ],
                                    ),
                                  ],
                                ],
                              ),

                              SizedBox(height: 16),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 12),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  final isCurrentUserClient =
                                      engagement.clientHashcode.toString() ==
                                      Prefs.getId;
                                  if (isCurrentUserClient) {
                                    Get.toNamed(
                                      RouteConstant.freelancerMemberProfileScreen,
                                      arguments: User(
                                        hashcode: engagement.freelancerHashcode,
                                      ),
                                    );
                                  } else {
                                    Get.toNamed(
                                      RouteConstant.employerMemberProfileScreen,
                                      arguments: User(
                                        hashcode: engagement.clientHashcode,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.resources.color.colorWhite,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: context.resources.color.colorPrimary,
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
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          child: PrimaryNetworkImage(
                                            url: memberImage,
                                            width: 35,
                                            height: 35,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Flexible(
                                        child: PrimaryText(
                                          text:
                                              '$memberFirstName\n$memberLastName',
                                          fontSize: 12,
                                          maxLines: 2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Image.asset(AppIcons.star2, width: 12),
                                      SizedBox(width: 2),
                                      PrimaryText(
                                        text: memberRating.toString(),
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
                                color: context.resources.color.colorPrimaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:  PrimaryText(
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

                      // Member pill
                      SizedBox(height: 20),

                      // ── Skills / Services card ────────────────────────────
                      if (engagement.type.toString() == 'SB' &&
                          engagement.services != null &&
                          engagement.services!.isNotEmpty &&
                          engagement.services!.first.skills != null &&
                          engagement.services!.first.skills!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.all(12),
                          decoration: _cardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryText(
                                text: context.resources.strings.skills,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: engagement.services!.first.skills!
                                    .map((skill) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context
                                              .resources
                                              .color
                                              .colorPrimaryLight,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
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
                                    })
                                    .toList(),
                              ),
                            ],
                          ),
                        ),

                      if (engagement.type.toString() == 'JA' &&
                          engagement.job != null &&
                          engagement.job!.skills != null &&
                          engagement.job!.skills!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.all(12),
                          decoration: _cardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryText(
                                text: context.resources.strings.skills,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: engagement.job!.skills!.map((skill) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context
                                          .resources
                                          .color
                                          .colorPrimaryLight,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: PrimaryText(
                                      text: skill.name ?? '',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textColor:
                                          context.resources.color.colorPrimary,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                      if (engagement.type.toString() == 'PB' &&
                          engagement.package != null &&
                          engagement.package!.services != null &&
                          engagement.package!.services!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.all(12),
                          decoration: _cardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryText(
                                text: context.resources.strings.services,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: engagement.package!.services!.map((
                                  service,
                                ) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context
                                          .resources
                                          .color
                                          .colorPrimaryLight,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: PrimaryText(
                                      text: service.title ?? '',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textColor:
                                          context.resources.color.colorPrimary,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 16),

                      // ── Details card ──────────────────────────────────────
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.all(12),
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (engagement.estimatedHours != null) ...[
                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context
                                        .resources
                                        .strings
                                        .estimatedHours,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        context.resources.color.colorBlack,
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          context.resources.color.colorGrey28,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: PrimaryText(
                                      text:
                                          '${engagement.estimatedHours} ${context.resources.strings.hours}',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      textColor:
                                          context.resources.color.colorGrey7,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            if (engagement.description != null &&
                                engagement.description
                                    .toString()
                                    .isNotEmpty) ...[
                              SizedBox(height: 16),
                              PrimaryText(
                                text: context.resources.strings.description,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorGrey28,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: PrimaryText(
                                  text:
                                      engagement.description ??
                                      context.resources.strings.notAvailable,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  textColor: context.resources.color.colorGrey7,
                                ),
                              ),
                            ],

                            if (engagement.tasksMilestones != null &&
                                engagement.tasksMilestones
                                    .toString()
                                    .isNotEmpty) ...[
                              SizedBox(height: 16),
                              PrimaryText(
                                text: context.resources.strings.milestones,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorGrey28,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: PrimaryText(
                                  text:
                                      engagement.tasksMilestones ??
                                      context.resources.strings.notAvailable,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  textColor: context.resources.color.colorGrey7,
                                ),
                              ),
                            ],

                            if ((engagement.type.toString() == 'SB' ||
                                    engagement.type.toString() == 'PB') &&
                                engagement.messageToFreelancer != null &&
                                engagement.messageToFreelancer
                                    .toString()
                                    .isNotEmpty) ...[
                              SizedBox(height: 16),
                              PrimaryText(
                                text: context
                                    .resources
                                    .strings
                                    .messageToFreelancer,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorGrey28,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: PrimaryText(
                                  text:
                                      engagement.messageToFreelancer ??
                                      context.resources.strings.notAvailable,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  textColor: context.resources.color.colorGrey7,
                                ),
                              ),
                            ],

                            if (engagement.type.toString() == 'JA' &&
                                engagement.messageToClient != null &&
                                engagement.messageToClient
                                    .toString()
                                    .isNotEmpty) ...[
                              SizedBox(height: 16),
                              PrimaryText(
                                text: context.resources.strings.messageToClient,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorGrey28,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: PrimaryText(
                                  text:
                                      engagement.messageToClient ??
                                      context.resources.strings.notAvailable,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  textColor: context.resources.color.colorGrey7,
                                ),
                              ),
                            ],

                            if (engagement.type.toString() == 'JA' &&
                                engagement.freelancerCv != null &&
                                engagement.freelancerCv!.isNotEmpty) ...[
                              SizedBox(height: 16),
                              PrimaryText(
                                text: context.resources.strings.uploadCv,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _openFileInBrowser(
                                  engagement.freelancerCv!,
                                  context,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: context
                                        .resources
                                        .color
                                        .colorPrimaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: context
                                          .resources
                                          .color
                                          .colorPrimary
                                          .withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        AppIcons.fileCv,
                                        width: 28,
                                        height: 28,
                                        color: context
                                            .resources
                                            .color
                                            .colorPrimary,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            PrimaryText(
                                              text: context
                                                  .resources
                                                  .strings
                                                  .cvFile,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey,
                                            ),
                                            SizedBox(height: 4),
                                            PrimaryText(
                                              text: engagement.freelancerCv!
                                                  .split('/')
                                                  .last,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              textColor: context
                                                  .resources
                                                  .color
                                                  .colorGrey7,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Image.asset(
                                        AppIcons.fileDownload,
                                        width: 22,
                                        height: 22,
                                        color: context
                                            .resources
                                            .color
                                            .colorPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            if ((engagement.status == 4 ||
                                    engagement.status == 10) &&
                                engagement.completedDeliverables != null &&
                                engagement
                                    .completedDeliverables!
                                    .isNotEmpty) ...[
                              SizedBox(height: 16),
                              PrimaryText(
                                text: context
                                    .resources
                                    .strings
                                    .completedDeliverables,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack,
                              ),
                              SizedBox(height: 8),
                              if (_isImageFile(
                                engagement.completedDeliverables!,
                              ))
                                GestureDetector(
                                  onTap: () => _showExpandedImage(
                                    context,
                                    engagement.completedDeliverables!,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: PrimaryNetworkImage(
                                      url: engagement.completedDeliverables!,
                                      width: double.infinity,
                                      height: 250,
                                    ),
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: () => _openFileInBrowser(
                                    engagement.completedDeliverables!,
                                    context,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: context
                                          .resources
                                          .color
                                          .colorPrimaryLight,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: context
                                            .resources
                                            .color
                                            .colorPrimary
                                            .withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          AppIcons.fileCv,
                                          width: 28,
                                          height: 28,
                                          color: context
                                              .resources
                                              .color
                                              .colorPrimary,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PrimaryText(
                                                text: context
                                                    .resources
                                                    .strings
                                                    .deliverablesFile,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                              SizedBox(height: 4),
                                              PrimaryText(
                                                text: engagement
                                                    .completedDeliverables!
                                                    .split('/')
                                                    .last,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey7,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Image.asset(
                                          AppIcons.fileDownload,
                                          width: 22,
                                          height: 22,
                                          color: context
                                              .resources
                                              .color
                                              .colorPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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

            // ── Action buttons ─────────────────────────────────────────────
            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == 0) {
                if (engagement?.pendingChangeRequest == 1) {
                  final currentUserId = Prefs.getId;
                  final changeRequests = engagement?.changeRequests;
                  final isRequester =
                      changeRequests != null &&
                      changeRequests.isNotEmpty &&
                      changeRequests.first.requesterHashcode == currentUserId;

                  if (isRequester) {
                    return _buildBottomPanel(
                      context,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppIcons.clock,
                              width: 24,
                              height: 24,
                              color: context.resources.color.colorPrimary,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context
                                        .resources
                                        .strings
                                        .waitingForReply,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: context
                                        .resources
                                        .strings
                                        .yourChangeRequestPendingApproval,
                                    fontSize: 14,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return _buildBottomPanel(
                      context,
                      child: PrimaryButton(
                        title: context.resources.strings.viewChanges,
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
                  final currentUserId = Prefs.getId;
                  final engagementType = engagement?.type;
                  bool canAcceptReject = false;

                  if (engagementType == 'JA') {
                    canAcceptReject =
                        currentUserId == engagement?.clientHashcode;
                  } else if (engagementType == 'SB' || engagementType == 'PB') {
                    canAcceptReject =
                        currentUserId == engagement?.freelancerHashcode;
                  }

                  if (canAcceptReject) {
                    final hasChangeRequests =
                        engagement?.changeRequests != null &&
                        engagement!.changeRequests!.isNotEmpty;
                    // Job applications: no Negotiate/Inquiry — just Accept + Decline side-by-side.
                    // Service / Package bookings: Accept + Inquiry + Decline link below.
                    final showInquiry =
                        !hasChangeRequests && engagementType != 'JA';
                    final acceptGreen =
                        context.resources.color.colorGreen6;
                    final declineRed = context.resources.color.colorRed2;

                    void onAccept() {
                      controller.faceVerificationAction =
                          'accept_engagement';
                      Get.bottomSheet(
                        VerifyFaceMatchBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    }

                    void onDecline() {
                      controller.faceVerificationAction =
                          'reject_engagement';
                      Get.bottomSheet(
                        VerifyFaceMatchBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    }

                    return _buildBottomPanel(
                      context,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Obx(() {
                                  if (controller.isAccepting.value) {
                                    return _buildLoadingButton(
                                      context,
                                      color: acceptGreen,
                                    );
                                  }
                                  return PrimaryButton(
                                    title: Resources.of(context)
                                        .strings
                                        .acceptRequest,
                                    color: acceptGreen,
                                    onPressed: onAccept,
                                  );
                                }),
                              ),
                              const SizedBox(width: 12),
                              if (showInquiry)
                                Expanded(
                                  child: PrimaryButton(
                                    title:
                                        Resources.of(context).strings.negotiate,
                                    onPressed: () {
                                      Get.bottomSheet(
                                        NegotiationBottomSheet(),
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                      );
                                    },
                                  ),
                                )
                              else
                                Expanded(
                                  child: Obx(() {
                                    if (controller.isRejecting.value) {
                                      return _buildLoadingButton(
                                        context,
                                        color: declineRed,
                                      );
                                    }
                                    return PrimaryButton(
                                      title: Resources.of(context)
                                          .strings
                                          .decline,
                                      color: declineRed,
                                      onPressed: onDecline,
                                    );
                                  }),
                                ),
                            ],
                          ),
                          if (showInquiry) ...[
                            const SizedBox(height: 12),
                            Obx(() {
                              if (controller.isRejecting.value) {
                                return const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: onDecline,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4),
                                  child: PrimaryText(
                                    text: Resources.of(context).strings.decline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    textColor: declineRed,
                                    isUnderLined: true,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    );
                  } else {
                    return _buildBottomPanel(
                      context,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppIcons.clock,
                              width: 24,
                              height: 24,
                              color: context.resources.color.colorPrimary,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: context
                                        .resources
                                        .strings
                                        .waitingForReply,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text: context
                                        .resources
                                        .strings
                                        .yourTaskRequestPendingApproval,
                                    fontSize: 14,
                                    textColor:
                                        context.resources.color.colorGrey7,
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

            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == 1) {
                return _buildBottomPanel(
                  context,
                  child: Column(
                    children: [
                      if (Prefs.getId ==
                              engagement?.freelancerHashcode.toString() &&
                          engagement?.hasDispute.toString() == '0')
                        PrimaryButton(
                          title: Resources.of(context).strings.finishTask,
                          onPressed: () {
                            controller.faceVerificationAction =
                                'open_finish_sheet';
                            Get.bottomSheet(
                              VerifyFaceMatchBottomSheet(),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                        ),
                      if (Prefs.getId ==
                          engagement?.freelancerHashcode.toString())
                        SizedBox(height: 12),
                      PrimaryOutlinedButton(
                        title: Resources.of(context).strings.submitDispute,
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

            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == 4 &&
                  Prefs.getId == engagement?.clientHashcode.toString()) {
                return _buildBottomPanel(
                  context,
                  child: Column(
                    children: [
                      Obx(() {
                        if (controller.isAcceptingFinishEngagement.value) {
                          return _buildLoadingButton(
                            context,
                            color: context.resources.color.colorPrimary,
                          );
                        }
                        return PrimaryButton(
                          title: Resources.of(context).strings.acceptFinish,
                          onPressed: () {
                            controller.faceVerificationAction = 'accept_finish';
                            Get.bottomSheet(
                              VerifyFaceMatchBottomSheet(),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                        );
                      }),
                      SizedBox(height: 12),
                      Obx(() {
                        if (controller.isRejectingFinishEngagement.value) {
                          return _buildLoadingButton(
                            context,
                            color: context.resources.color.colorRed,
                          );
                        }
                        return PrimaryOutlinedButton(
                          title: Resources.of(context).strings.rejectFinish,
                          onPressed: controller.rejectFinishEngagement,
                        );
                      }),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),

            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == -3) {
                return _buildBottomPanel(
                  context,
                  child: PrimaryButton(
                    title: Resources.of(context).strings.submitDispute,
                    onPressed: () {
                      Get.bottomSheet(
                        DisputeBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                );
              }
              return SizedBox.shrink();
            }),

            Obx(() {
              final engagement = controller.engagement.value;
              if (engagement?.status == 10 &&
                  !(engagement?.isMemberRated == true &&
                      engagement?.isSubjectRated == true) &&
                  controller.shouldRateItem) {
                return _buildBottomPanel(
                  context,
                  child: PrimaryButton(
                    title: Resources.of(context).strings.rateTask,
                    onPressed: () {
                      Get.toNamed(
                        RouteConstant.rateEngagementScreen,
                        arguments: engagement,
                      );
                    },
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

  Widget _buildBackButton(BuildContext context, {String? statusLabel, String? statusColor}) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RotatedBox(
            quarterTurns: Utils().isRTL() ? 2 : 0,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Image.asset(AppIcons.back3, width: 38),
            ),
          ),
          if (statusLabel != null && statusColor != null)
            _StatusPill(label: statusLabel, hexColor: statusColor),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context, {required Widget child}) {
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
      child: child,
    );
  }

  Widget _buildLoadingButton(BuildContext context, {required Color color}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color,
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
}

/// Engagement status pill per Figma (p53 Revision / p55 Submitted / p56
/// Upcoming / p57 Request / p213 Application / p215 Inquiry). Backend hands
/// us a saturated hex; we use it as the text colour and derive a pastel
/// background by mixing the hex with white.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.hexColor});

  final String label;
  final String hexColor;

  @override
  Widget build(BuildContext context) {
    final base = HexColor(hexColor);
    final bg = Color.alphaBlend(base.withValues(alpha: 0.14), Colors.white);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: PrimaryText(
        text: label,
        textColor: base,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}
