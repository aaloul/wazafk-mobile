import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../../components/primary_text.dart';
import '../../../../../utils/res/AppIcons.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({super.key, required this.engagement});

  final Engagement engagement;

  void _handleTap() {
    // Navigate to engagement details screen
    Get.toNamed(RouteConstant.engagementDetailsScreen, arguments: engagement);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: engagement.type.toString() == 'SB'
              ? context.resources.color.colorBlue4.withOpacity(.5)
              : engagement.type.toString() == 'PB'
              ? context.resources.color.colorGreen5.withOpacity(.5)
              : context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.resources.color.colorGrey18,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: engagement.type.toString() == 'SB'
                            ? engagement.services?.first.title.toString() ??
                                  'N/A'
                            : engagement.type.toString() == 'PB'
                            ? engagement.package?.title.toString() ?? 'N/A'
                            : engagement.job?.title.toString() ?? 'N/A',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        textColor: context.resources.color.colorBlack3,
                      ),

                      PrimaryText(
                        text: engagement.description ?? 'N/A',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: context.resources.color.colorBlack3,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: HexColor(engagement.statusColor.toString()),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: PrimaryText(
                    text: engagement.statusLabel.toString(),
                    textColor: context.resources.color.colorWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.colorBlue,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(9999),
                    child: PrimaryNetworkImage(
                      url: engagement.clientHashcode.toString() == Prefs.getId
                          ? engagement.freelancerImage.toString()
                          : engagement.clientImage.toString(),
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),

                SizedBox(width: 6),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text:
                            engagement.clientHashcode.toString() == Prefs.getId
                            ? "${engagement.freelancerFirstName} ${engagement.freelancerLastName}"
                            : "${engagement.clientFirstName} ${engagement.clientLastName}",
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        textColor: context.resources.color.colorBlack,
                      ),
                      PrimaryText(
                        text:
                            engagement.clientHashcode.toString() == Prefs.getId
                            ? engagement.freelancerTitle ?? 'N/A'
                            : engagement.clientTitle ?? 'N/A',
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        textColor: context.resources.color.colorBlack,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: '\$${engagement.totalPrice.toString()}',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: context.resources.color.colorGreen6,
                      ),
                      SizedBox(height: 4),

                      PrimaryText(
                        text: context.resources.strings.totalValue,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: context.resources.color.colorGrey7,
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: '\$${engagement.remaining ?? '-'}',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: context.resources.color.colorBlue3,
                    ),

                    SizedBox(height: 4),

                    PrimaryText(
                      text: context.resources.strings.remaining,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: context.resources.color.colorGrey7,
                    ),
                  ],
                ),
              ],
            ),

            Container(
              width: double.infinity,
              height: 1,
              margin: EdgeInsets.symmetric(vertical: 12),
              color: context.resources.color.colorPrimary.withOpacity(.25),
            ),

            Row(
              children: [
                Image.asset(
                  AppIcons.calendar,
                  width: 20,
                  color: context.resources.color.colorGrey7,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: PrimaryText(
                    text:
                        "${context.resources.strings.due}: ${engagement.expiryDatetime != null ? DateFormat('MMM dd,yyyy').format(engagement.expiryDatetime!) : context.resources.strings.notAvailableShort}",
                    textColor: context.resources.color.colorGrey7,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
