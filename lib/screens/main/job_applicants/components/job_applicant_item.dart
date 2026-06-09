import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../components/primary_text.dart';
import '../../../../model/JobApplicantsResponse.dart';

class JobApplicantItem extends StatelessWidget {
  const JobApplicantItem({super.key, required this.applicantData});

  final JobApplicant applicantData;

  @override
  Widget build(BuildContext context) {
    final applicant = applicantData.applicant;
    final engagement = applicantData.engagement;

    return GestureDetector(
      onTap: () {
        if (engagement != null) {
          Get.toNamed(
            RouteConstant.engagementDetailsScreen,
            arguments: engagement,
          );
        }
      },
      child: Card(
        color: context.resources.color.colorWhite,
        elevation: 8,
        shadowColor: Colors.black26,
        margin: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: context.resources.color.colorGrey15,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
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
                  url: applicant?.image.toString() ?? '',
                  width: 52,
                  height: 52,
                ),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: PrimaryText(
                          text:
                              '${applicant?.firstName ?? ''} ${applicant?.lastName ?? ''}'
                                  .trim(),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          textColor: context.resources.color.colorBlack,
                        ),
                      ),
                      SizedBox(width: 6),
                      Image.asset(AppIcons.star2, width: 14),
                      SizedBox(width: 2),
                      PrimaryText(
                        text: applicant?.rating.toString() ?? '0',
                        fontSize: 12,
                        textColor: context.resources.color.colorBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  PrimaryText(
                    text:
                        '${applicant?.nbCompletedJobs ?? 0} ${context.resources.strings.completedJobs}',
                    fontSize: 13,
                    textColor: context.resources.color.colorGrey19,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8),

            RotatedBox(
              quarterTurns: Utils().isRTL() ? 2 : 0,
              child: Image.asset(
                AppIcons.arrowRight2,
                width: 18,
                color: context.resources.color.colorGrey26,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
