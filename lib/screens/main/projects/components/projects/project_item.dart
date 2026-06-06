import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
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
                        PrimaryText(
                          text: engagement.description ??
                              context.resources.strings.notAvailableShort,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey26,
                          maxLines: 1,
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
                    text: _getDueDate(context),
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
            ],
          ),
        ),
      ),
    );
  }
}
