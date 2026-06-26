import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/screens/main/engagement_details/components/engagement_common.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

/// "Today's Schedule" card (Figma p229–231): title + status badge, location
/// row, an optional relative "Job Due in N days" row, then avatar + name +
/// rating and the price. Taps through to the engagement details.
class ScheduleEngagementCard extends StatelessWidget {
  const ScheduleEngagementCard({super.key, required this.engagement});

  final Engagement engagement;

  String _title(BuildContext context) {
    switch (engagement.type) {
      case 'SB':
        return engagement.services?.first.title ??
            context.resources.strings.notAvailableShort;
      case 'PB':
        return engagement.package?.title ??
            context.resources.strings.notAvailableShort;
      default:
        return engagement.job?.title ??
            context.resources.strings.notAvailableShort;
    }
  }

  String _location(BuildContext context) {
    final code = engagement.workLocationType?.trim() ?? '';
    // Map the work-location code (e.g. RMT) to its readable name (Remote).
    final type =
        code.isNotEmpty ? engagementWorkLocationTypeName(context, code) : '';
    final city = engagement.address?.city?.trim() ??
        engagement.address?.address?.trim() ??
        '';
    return [
      if (type.isNotEmpty) type,
      if (city.isNotEmpty) city,
    ].join(' – ');
  }

  String? _dueText(dynamic strings) {
    int? days = engagement.dueDays;
    if (days == null && engagement.dueDatetime != null) {
      final due = engagement.dueDatetime!;
      final now = DateTime.now();
      days = DateTime(due.year, due.month, due.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
    }
    if (days == null || days < 0) return null;
    return days == 0 ? strings.jobDueToday : strings.jobDueInDays(days);
  }

  bool get _isClient => engagement.clientHashcode.toString() == Prefs.getId;

  String _otherPartyName() => _isClient
      ? '${engagement.freelancerFirstName ?? ''} ${engagement.freelancerLastName ?? ''}'
          .trim()
      : '${engagement.clientFirstName ?? ''} ${engagement.clientLastName ?? ''}'
          .trim();

  String _otherPartyImage() =>
      (_isClient ? engagement.freelancerImage : engagement.clientImage)
          .toString();

  String _otherPartyRating() =>
      (_isClient ? engagement.freelancerRating : engagement.clientRating) ??
      '0';

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final location = _location(context);
    final dueText = _dueText(strings);

    return GestureDetector(
      onTap: () => Get.toNamed(
        RouteConstant.engagementDetailsScreen,
        arguments: engagement,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.colorGrey15, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PrimaryText(
                    text: _title(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    textColor: colors.colorGrey16,
                    maxLines: 1,
                  ),
                ),
                if (engagement.statusLabel != null) ...[
                  const SizedBox(width: 8),
                  Builder(builder: (_) {
                    final base = HexColor(engagement.statusColor.toString());
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: Color.alphaBlend(
                          base.withValues(alpha: 0.14),
                          Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: PrimaryText(
                        text: engagement.statusLabel.toString(),
                        textColor: base,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  }),
                ],
              ],
            ),

            // Location
            if (location.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppIcons.location,
                      width: 14, color: colors.colorGrey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: PrimaryText(
                      text: location,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: colors.colorGrey26,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],

            // Relative due date
            if (dueText != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(AppIcons.calendar,
                      width: 14, color: colors.colorPrimary),
                  const SizedBox(width: 4),
                  PrimaryText(
                    text: dueText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: colors.colorPrimary,
                  ),
                ],
              ),
            ],

            // Divider
            Container(
              width: double.infinity,
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 12),
              color: colors.colorGrey20,
            ),

            // Footer: avatar | name + rating | price
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: colors.colorPrimary, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: PrimaryNetworkImage(
                      url: _otherPartyImage(),
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: PrimaryText(
                          text: _otherPartyName(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(AppIcons.star2, width: 12),
                      const SizedBox(width: 2),
                      PrimaryText(
                        text: _otherPartyRating(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                PrimaryText(
                  text: '\$ ${engagement.totalPrice ?? '0'}',
                  textColor: colors.colorPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
