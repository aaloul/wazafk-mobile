import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../../model/JobsResponse.dart';

class ProjectsJobItem extends StatelessWidget {
  const ProjectsJobItem({
    super.key,
    required this.job,
    this.onFavoriteToggle,
    this.isRemoving = false,
  });

  final Job job;
  final Function(String)? onFavoriteToggle;
  final bool isRemoving;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstant.jobDetailsScreen, arguments: job);
      },
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
              // Header: title + location | applicants badge | favorite
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          text: job.title.toString(),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorGrey16,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Image.asset(
                              AppIcons.location,
                              width: 18,
                              color: context.resources.color.colorGrey29,
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: PrimaryText(
                                text: _getWorkLocationTypeName(
                                  context,
                                  job.workLocationType,
                                ),
                                textColor: context.resources.color.colorGrey26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Applicants badge
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: context.resources.color.colorGrey30,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppIcons.file,
                          width: 12,
                          color: context.resources.color.colorPrimary,
                        ),
                        SizedBox(width: 4),
                        PrimaryText(
                          text: job.nbApplicants.toString(),
                          textColor: context.resources.color.colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6),

                  // Favorite button
                  GestureDetector(
                    onTap: isRemoving
                        ? null
                        : () {
                            if (onFavoriteToggle != null &&
                                job.hashcode != null) {
                              onFavoriteToggle!(job.hashcode!);
                            }
                          },
                    child: isRemoving
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: ProgressBar(),
                          )
                        : Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.resources.color.colorGrey15,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                job.isFavorite ?? false
                                    ? AppIcons.banomarkOn
                                    : AppIcons.banomark,
                                width: 15,
                                color: context.resources.color.colorPrimary,
                              ),
                            ),
                          ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Skills pills
              if (job.skills != null && job.skills!.isNotEmpty)
                SizedBox(
                  height: 26,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: job.skills!.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final skill = job.skills![index];
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimaryLight,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: PrimaryText(
                            text: skill.name.toString(),
                            textColor: context.resources.color.colorPrimary,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Divider
              Container(
                width: double.infinity,
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 12),
                color: context.resources.color.colorGrey20,
              ),

              // Footer: avatar | name + rating + date | price
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (job.memberHashcode != null) {
                        Get.toNamed(
                          RouteConstant.employerMemberProfileScreen,
                          arguments: User(
                            hashcode: job.memberHashcode,
                            image: job.memberImage,
                            firstName: job.memberFirstName,
                            lastName: job.memberLastName,
                            title: '',
                          ),
                        );
                      }
                    },
                    child: Container(
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
                          url: job.memberImage.toString(),
                          width: 35,
                          height: 35,
                        ),
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
                              text:
                                  '${job.memberFirstName} ${job.memberLastName}',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(width: 6),
                            Image.asset(AppIcons.star2, width: 12),
                            SizedBox(width: 2),
                            PrimaryText(
                              text: job.rating.toString(),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        PrimaryText(
                          text: job.startDatetime != null
                              ? DateFormat("dd-MM-yyyy")
                                  .format(job.startDatetime!)
                              : '',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey10,
                        ),
                      ],
                    ),
                  ),

                  PrimaryText(
                    text: "\$${job.totalPrice}",
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
