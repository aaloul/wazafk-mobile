import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../constants/route_constant.dart';
import 'engagement_common.dart';

/// White shadowed header card: back bar + status pill, title (tappable to the
/// underlying job/service/package), category path, and — for job engagements —
/// the inline location and start/due dates (design p213/p56). Service and
/// package engagements render location/dates as separate body cards instead.
class EngagementHeaderCard extends StatelessWidget {
  const EngagementHeaderCard({
    super.key,
    this.showCategory = true,
    this.inlineLocationAndDates = false,
  });

  final bool showCategory;
  final bool inlineLocationAndDates;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final engagement = controller.engagement.value!;

    final title = controller.isJob.value
        ? controller.job.value?.title
        : controller.isPackage.value
            ? controller.package.value?.title
            : controller.service.value?.title;

    final categoryName = controller.isJob.value
        ? controller.job.value?.categoryName
        : controller.isPackage.value
            ? (controller.package.value?.services != null &&
                    controller.package.value!.services!.isNotEmpty
                ? controller.package.value!.services!.first.categoryName
                : context.resources.strings.package)
            : controller.service.value?.categoryName;

    final parentCategoryName = controller.isJob.value
        ? controller.job.value?.parentCategoryName
        : controller.isPackage.value
            ? (controller.package.value?.services != null &&
                    controller.package.value!.services!.isNotEmpty
                ? controller.package.value!.services!.first.parentCategoryName
                : null)
            : controller.service.value?.parentCategoryName;

    return Container(
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EngagementBackBar(
            statusLabel: engagement.statusLabel?.toString(),
            statusColor: engagement.statusColor?.toString(),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _openUnderlyingDetails(controller),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: title ?? '',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorBlack,
                  ),
                  if (showCategory) ...[
                    const SizedBox(height: 4),
                    PrimaryText(
                      text: parentCategoryName != null
                          ? '$parentCategoryName / $categoryName'
                          : categoryName ?? '',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      textColor: context.resources.color.colorGrey,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (inlineLocationAndDates) ...[
            const SizedBox(height: 8),
            _InlineLocation(engagement: engagement),
            const SizedBox(height: 8),
            _InlineDates(engagement: engagement),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _openUnderlyingDetails(EngagementDetailsController controller) {
    if (controller.isJob.value && controller.job.value != null) {
      Get.toNamed(RouteConstant.jobDetailsScreen,
          arguments: controller.job.value);
    } else if (controller.isService.value && controller.service.value != null) {
      Get.toNamed(RouteConstant.serviceDetailsScreen,
          arguments: controller.service.value);
    } else if (controller.isPackage.value && controller.package.value != null) {
      Get.toNamed(RouteConstant.packageDetailsScreen,
          arguments: controller.package.value);
    }
  }
}

class _InlineLocation extends StatelessWidget {
  const _InlineLocation({required this.engagement});

  final Engagement engagement;

  @override
  Widget build(BuildContext context) {
    final grey = context.resources.color.colorGrey29;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 16),
        Image.asset(AppIcons.location,
            width: 12, color: context.resources.color.colorGrey),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (engagement.workLocationType.toString().isNotEmpty)
                PrimaryText(
                  text: engagementWorkLocationTypeName(
                      context, engagement.workLocationType),
                  textColor: grey,
                ),
              if (engagement.workLocationType?.toString() != 'RMT' &&
                  engagement.address != null) ...[
                if (engagement.address!.city != null)
                  PrimaryText(
                      text: engagement.address!.city ?? '',
                      fontSize: 13,
                      textColor: grey),
                if (engagement.address!.street != null)
                  PrimaryText(
                      text: engagement.address!.street ?? '',
                      fontSize: 13,
                      textColor: grey),
                if (engagement.address!.building != null ||
                    engagement.address!.apartment != null)
                  PrimaryText(
                    text:
                        '${engagement.address!.building ?? ''} ${engagement.address!.apartment ?? ''}'
                            .trim(),
                    fontSize: 13,
                    textColor: grey,
                  ),
                if (engagement.address!.address != null)
                  PrimaryText(
                      text: engagement.address!.address ?? '',
                      fontSize: 13,
                      textColor: grey),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineDates extends StatelessWidget {
  const _InlineDates({required this.engagement});

  final Engagement engagement;

  @override
  Widget build(BuildContext context) {
    final grey = context.resources.color.colorGrey29;
    return Row(
      children: [
        if (engagement.startDatetime != null) ...[
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Image.asset(AppIcons.calendar,
                    width: 14, color: context.resources.color.colorGrey26),
                const SizedBox(width: 4),
                PrimaryText(
                  text:
                      '${context.resources.strings.start}: ${DateFormat('MMM dd, yyyy').format(engagement.startDatetime!)}',
                  textColor: grey,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ],
        if (engagement.expiryDatetime != null) ...[
          Row(
            children: [
              const SizedBox(width: 16),
              Image.asset(AppIcons.calendar,
                  width: 14, color: context.resources.color.colorGrey26),
              const SizedBox(width: 4),
              PrimaryText(
                text:
                    '${context.resources.strings.due}: ${DateFormat('MMM dd, yyyy').format(engagement.expiryDatetime!)}',
                textColor: grey,
                fontSize: 12,
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ],
    );
  }
}

/// Member pill (tap → other party profile) + price chip. Shared by all types.
class EngagementMemberPriceRow extends StatelessWidget {
  const EngagementMemberPriceRow({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final engagement = controller.engagement.value!;
    final isCurrentUserClient =
        engagement.clientHashcode.toString() == Prefs.getId;

    final unitPrice = controller.isPackage.value
        ? engagement.totalPrice
        : controller.isService.value
            ? (controller.service.value?.pricingType.toString() == 'U'
                ? engagement.unitPrice
                : engagement.totalPrice)
            : controller.isJob.value
                ? engagement.totalPrice
                : engagement.unitPrice ?? 'N/A';

    final priceTitle = controller.isJob.value
        ? context.resources.strings.totalPrice
        : controller.isPackage.value
            ? context.resources.strings.totalPrice
            : controller.service.value?.pricingType.toString() == 'U'
                ? context.resources.strings.hourlyRate
                : context.resources.strings.totalPrice;

    final memberFirstName =
        isCurrentUserClient ? '${engagement.freelancerFirstName}' : '${engagement.clientFirstName}';
    final memberLastName =
        isCurrentUserClient ? '${engagement.freelancerLastName}' : '${engagement.clientLastName}';
    final memberImage = isCurrentUserClient
        ? engagement.freelancerImage.toString()
        : engagement.clientImage.toString();
    final memberRating = isCurrentUserClient
        ? engagement.freelancerRating ?? '0'
        : engagement.clientRating ?? '0';

    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                if (isCurrentUserClient) {
                  Get.toNamed(RouteConstant.freelancerMemberProfileScreen,
                      arguments: User(hashcode: engagement.freelancerHashcode));
                } else {
                  Get.toNamed(RouteConstant.employerMemberProfileScreen,
                      arguments: User(hashcode: engagement.clientHashcode));
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: context.resources.color.colorWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: context.resources.color.colorPrimary, width: 1),
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
                            color: context.resources.color.colorPrimary,
                            width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: PrimaryNetworkImage(
                            url: memberImage, width: 35, height: 35),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: PrimaryText(
                        text: '$memberFirstName\n$memberLastName',
                        fontSize: 12,
                        maxLines: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(AppIcons.star2, width: 12),
                    const SizedBox(width: 2),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              color: context.resources.color.colorPrimaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: PrimaryText(
              text: '$priceTitle: \$$unitPrice',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              maxLines: 2,
              textColor: context.resources.color.colorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
