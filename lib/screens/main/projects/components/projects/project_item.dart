import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../../utils/res/AppIcons.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({super.key, required this.engagement});

  final Engagement engagement;

  String _getTitle(BuildContext context) {
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

  String _getOtherPartyName() {
    return engagement.clientHashcode.toString() == Prefs.getId
        ? '${engagement.freelancerFirstName ?? ''} ${engagement.freelancerLastName ?? ''}'.trim()
        : '${engagement.clientFirstName ?? ''} ${engagement.clientLastName ?? ''}'.trim();
  }

  String _getOtherPartyTitle(BuildContext context) {
    return engagement.clientHashcode.toString() == Prefs.getId
        ? engagement.freelancerTitle ??
            context.resources.strings.notAvailableShort
        : engagement.clientTitle ??
            context.resources.strings.notAvailableShort;
  }

  String _getOtherPartyImage() {
    return engagement.clientHashcode.toString() == Prefs.getId
        ? engagement.freelancerImage.toString()
        : engagement.clientImage.toString();
  }

  String _getOtherPartyRating() {
    return engagement.clientHashcode.toString() == Prefs.getId
        ? engagement.freelancerRating ?? '0'
        : engagement.clientRating ?? '0';
  }

  String _getDueDate(BuildContext context) {
    if (engagement.expiryDatetime == null) {
      return context.resources.strings.notAvailableShort;
    }
    return DateFormat('dd-MM-yyyy').format(engagement.expiryDatetime!);
  }

  /// Location line shown under the title (design p49–62): "Hybrid – Beirut".
  /// Falls back to the description when no location is available.
  String _location(BuildContext context) {
    final type = engagement.workLocationType?.trim() ?? '';
    final city = engagement.address?.city?.trim() ??
        engagement.address?.address?.trim() ??
        '';
    final s = [if (type.isNotEmpty) type, if (city.isNotEmpty) city].join(' – ');
    return s.isNotEmpty
        ? s
        : (engagement.description ??
            context.resources.strings.notAvailableShort);
  }

  /// Relative due label ("Job Due in N days"), falling back to the absolute
  /// expiry date.
  String _dueText(BuildContext context) {
    final strings = context.resources.strings;
    int? days = engagement.dueDays;
    if (days == null && engagement.dueDatetime != null) {
      final due = engagement.dueDatetime!;
      final now = DateTime.now();
      days = DateTime(due.year, due.month, due.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
    }
    if (days != null && days >= 0) {
      return days == 0 ? strings.jobDueToday : strings.jobDueInDays(days);
    }
    return _getDueDate(context);
  }

  /// Whether the current user must respond with Accept/Decline — mirrors the
  /// details screen's _PendingActions condition: status == 0, no pending change
  /// request, and the user is the responder (JA → client; SB/PB → freelancer).
  bool _canAcceptReject() {
    if (engagement.status != 0) return false;
    if (engagement.pendingChangeRequest == 1) return false;
    final uid = Prefs.getId;
    switch (engagement.type) {
      case 'JA':
        return (engagement.clientHashcode?.toString() ?? '') == uid;
      case 'SB':
      case 'PB':
        return (engagement.freelancerHashcode?.toString() ?? '') == uid;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(RouteConstant.engagementDetailsScreen, arguments: engagement),
      child: Card(
        color: context.resources.color.colorWhite,
        elevation: 8,
        shadowColor: Colors.black26,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: context.resources.color.colorGrey15,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: title + description | status badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          text: _getTitle(context),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorGrey16,
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              AppIcons.location,
                              width: 13,
                              color: context.resources.color.colorGrey26,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: PrimaryText(
                                text: _location(context),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                textColor:
                                    context.resources.color.colorGrey26,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  // Status badge — pastel bg + bold base-color text per Figma.
                  Builder(builder: (context) {
                    final base =
                        HexColor(engagement.statusColor.toString());
                    final bg = Color.alphaBlend(
                      base.withValues(alpha: 0.14),
                      Colors.white,
                    );
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: bg,
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
              ),


              Row(
                children: [
                  Image.asset(
                    AppIcons.calendar,
                    width: 14,
                    color: context.resources.color.colorPrimary,
                  ),
                  SizedBox(width: 3),
                  PrimaryText(
                    text: _dueText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: context.resources.color.colorPrimary,
                  ),
                ],
              ),
              // Divider
              Container(
                width: double.infinity,
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 12),
                color: context.resources.color.colorGrey20,
              ),

              // Footer: avatar | name + due date | price
              Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.resources.color.colorPrimary,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: PrimaryNetworkImage(
                        url: _getOtherPartyImage(),
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            PrimaryText(
                              text: _getOtherPartyName(),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(width: 6),
                            Image.asset(AppIcons.star2, width: 12),
                            SizedBox(width: 2),
                            PrimaryText(
                              text: _getOtherPartyRating(),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PrimaryText(
                    text: '\$${engagement.totalPrice ?? '0'}',
                    textColor: context.resources.color.colorPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),

              // Accept / Decline (design p54) — shown only when this user must
              // respond. The verified accept/reject (face-match) flow lives on
              // the details screen, so both route there.
              if (_canAcceptReject()) ...[
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _CardActionButton(
                        label: context.resources.strings.accept,
                        color: HexColor('#6CC192'),
                        onTap: () => Get.put(EngagementDetailsController())
                            .startActionFromList(
                                engagement, 'accept_engagement'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _CardActionButton(
                        label: context.resources.strings.decline,
                        color: HexColor('#E45959'),
                        onTap: () => Get.put(EngagementDetailsController())
                            .startActionFromList(
                                engagement, 'reject_engagement'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Solid pill action button used for the in-card Accept / Decline (design p54).
class _CardActionButton extends StatelessWidget {
  const _CardActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: PrimaryText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
