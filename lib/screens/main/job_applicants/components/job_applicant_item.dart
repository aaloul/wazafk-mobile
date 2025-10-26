import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

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
        if (applicant != null) {
          Get.toNamed(
            RouteConstant.freelancerMemberProfileScreen,
            arguments: applicant,
          );
        }
      },
      child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: context.resources.color.colorBlue2),
      child: Row(
        children: [
          // Avatar
          SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: PrimaryNetworkImage(
                url: applicant?.image.toString() ?? '',
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          Container(
            width: 1,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 14),
            color: context.resources.color.colorWhite.withOpacity(.5),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text:
                      '${applicant?.firstName ?? ''} ${applicant?.lastName ?? ''}',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  textColor: context.resources.color.colorBlue3,
                ),
                SizedBox(height: 2),

                PrimaryText(
                  text: '${applicant?.nbCompletedJobs ?? 0} Completed Jobs',
                  fontSize: 14,
                  textColor: context.resources.color.colorBlue3,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 2),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AppIcons.star2, width: 16),
                    SizedBox(width: 2),
                    PrimaryText(
                      text: applicant?.rating.toString() ?? '0',
                      fontSize: 14,
                      textColor: context.resources.color.colorBlue3,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Image.asset(AppIcons.banomark, width: 20),
        ],
      ),
      ),
    );
  }
}
