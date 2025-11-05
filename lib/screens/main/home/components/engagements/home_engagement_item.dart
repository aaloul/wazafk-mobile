import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

class HomeEngagementItem extends StatelessWidget {
  const HomeEngagementItem({super.key, required this.engagement});

  final Engagement engagement;

  void _handleEngagementClick() {
    if (engagement.type.toString() == 'SB') {
      // Open service details
      if (engagement.services != null && engagement.services!.isNotEmpty) {
        Get.toNamed(
          RouteConstant.serviceDetailsScreen,
          arguments: engagement.services!.first,
        );
      }
    } else if (engagement.type.toString() == 'PB') {
      // Open package details
      if (engagement.package != null) {
        Get.toNamed(
          RouteConstant.packageDetailsScreen,
          arguments: engagement.package,
        );
      }
    } else if (engagement.type.toString() == 'JA') {
      // Open job details
      if (engagement.job != null) {
        Get.toNamed(
          RouteConstant.jobDetailsScreen,
          arguments: engagement.job,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleEngagementClick,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.resources.color.colorGrey18,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title
            PrimaryText(
              text: engagement.type.toString() == 'SB'
                  ? engagement.services?.first.title.toString() ?? 'N/A'
                  : engagement.type.toString() == 'PB'
                  ? engagement.package?.title.toString() ?? 'N/A'
                  : engagement.job?.title.toString() ?? 'N/A',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              textColor: context.resources.color.colorBlack,
              maxLines: 1,
            ),
            SizedBox(height: 2),
            PrimaryText(
              text: engagement.description.toString(),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              textColor: context.resources.color.colorGrey19,
              maxLines: 2,
            ),

            SizedBox(height: 12),

            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              AppIcons.location,
                              width: 18,
                              color: context.resources.color.colorGrey19,
                            ),
                            SizedBox(width: 6),
                            PrimaryText(
                              text: engagement.workLocationType
                                  .toString()
                                  .isEmpty
                                  ? "N/A"
                                  : engagement.workLocationType ?? "N/A",
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey19,
                            ),
                          ],
                        ),
                      ),

                      PrimaryText(
                        text: "\$${engagement.totalPrice}",
                        textColor: context.resources.color.colorGreen3,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  SizedBox(height: 6),

                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              AppIcons.clock,
                              width: 20,
                              color: context.resources.color.colorGrey19,
                            ),
                            SizedBox(width: 6),
                            PrimaryText(
                              text: "${engagement.estimatedHours} Hours",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey19,
                            ),
                          ],
                        ),
                      ),

                      PrimaryText(
                        text: "Total Value",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: context.resources.color.colorGrey19,
                      ),
                    ],
                  ),
                ],
              ),
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
                  color: context.resources.color.colorGrey19,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: PrimaryText(
                    text:
                    "Due:${ engagement.expiryDatetime != null ? DateFormat(
                        'MMM dd,yyyy').format(
                        engagement.expiryDatetime!) : 'N/A'}",
                    textColor: context.resources.color.colorGrey19,
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
