import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/outlined_button.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/screens/main/job_details/job_details_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/auth_guard.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/progress_bar.dart';
import 'components/job_details_header.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobDetailsController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                // Show loading indicator
                if (controller.isLoading.value) {
                  return Center(
                    child: ProgressBar(
                      color: context.resources.color.colorPrimary,
                    ),
                  );
                }

                final job = controller.job.value;
                if (job == null) {
                  return Center(
                    child: PrimaryText(
                      text: context.resources.strings.noJobDetailsAvailable,
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JobDetailsHeader(job: controller.job.value!),

                      SizedBox(height: 20),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Employer info + price
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.resources.color.colorWhite,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          context.resources.color.colorPrimary,
                                      width: 1,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (job.memberHashcode != null) {
                                        Get.toNamed(
                                          RouteConstant
                                              .employerMemberProfileScreen,
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
                                    child: Row(
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
                                              url: job.memberImage.toString(),
                                              width: 35,
                                              height: 35,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6),

                                        PrimaryText(
                                          text:
                                              '${job.memberFirstName} ${job.memberLastName}',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        SizedBox(width: 2),
                                        Row(
                                          children: [
                                            Image.asset(
                                              AppIcons.star2,
                                              width: 12,
                                            ),
                                            SizedBox(width: 1),
                                            PrimaryText(
                                              text: job.memberRating ?? 'N/A',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context
                                        .resources
                                        .color
                                        .colorPrimaryLight,
                                    borderRadius: BorderRadius.circular(12),

                                  ),
                                  child: PrimaryText(
                                    text: 'Payment: \$${job.totalPrice ?? '0'}',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        context.resources.color.colorPrimary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),

                            // Skills
                            if (job.skills != null &&
                                job.skills!.isNotEmpty) ...[
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE5E5E5),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PrimaryText(
                                      text: 'Skills Required',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      textColor:
                                          context.resources.color.colorBlack,
                                    ),
                                    SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: job.skills!.map((skill) {
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
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                            ],

                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE5E5E5),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (job.description != null &&
                                      job.description!.isNotEmpty) ...[
                                    PrimaryText(
                                      text: context.resources.strings.about,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      textColor:
                                          context.resources.color.colorBlack,
                                    ),
                                    SizedBox(height: 4),
                                    PrimaryText(
                                      text: job.description!,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textColor:
                                          context.resources.color.colorGrey31,
                                    ),
                                    SizedBox(height: 16),
                                  ],

                                  // "About the job" — the overview captured on
                                  // the post form.
                                  if (job.overview != null &&
                                      job.overview!.isNotEmpty) ...[
                                    PrimaryText(
                                      text: context
                                          .resources
                                          .strings
                                          .aboutTheJob,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      textColor:
                                          context.resources.color.colorBlack,
                                    ),
                                    SizedBox(height: 4),
                                    PrimaryText(
                                      text: job.overview!,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textColor:
                                          context.resources.color.colorGrey31,
                                    ),
                                    SizedBox(height: 16),
                                  ],

                                  PrimaryText(
                                    text: context
                                        .resources
                                        .strings
                                        .responsibilities,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        context.resources.color.colorBlack,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text:
                                        job.responsibilities ??
                                        context.resources.strings.notAvailable,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textColor:
                                        context.resources.color.colorGrey31,
                                  ),

                                  SizedBox(height: 16),

                                  PrimaryText(
                                    text:
                                        context.resources.strings.requirements,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        context.resources.color.colorBlack,
                                  ),
                                  SizedBox(height: 4),
                                  PrimaryText(
                                    text:
                                        job.requirememts ??
                                        context.resources.strings.notAvailable,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textColor:
                                        context.resources.color.colorGrey31,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),

                            if (job.memberHashcode.toString() != Prefs.getId)
                              // Show View Engagement button if user has an engagement
                              if (job.hasEngagement == 1)
                                PrimaryButton(
                                  title: context.resources.strings.viewTask,
                                  onPressed: () {
                                    Get.toNamed(
                                      RouteConstant.engagementDetailsScreen,
                                      arguments: job.hasEngagementHashcode,
                                    );
                                  },
                                )
                              else
                                PrimaryButton(
                                  title: context.resources.strings.applyNow,
                                  onPressed: () {
                                    if (!requireLogin()) return;
                                    Get.toNamed(
                                      RouteConstant.applyJobScreen,
                                      arguments: job,
                                    );
                                  },
                                ),

                            if (job.memberHashcode.toString() == Prefs.getId)
                              PrimaryButton(
                                title:
                                    context.resources.strings.viewApplications,
                                onPressed: () {
                                  if (job.hashcode != null) {
                                    Get.toNamed(
                                      RouteConstant.jobApplicantsScreen,
                                      arguments: job.hashcode,
                                    );
                                  }
                                },
                              ),

                            if (job.memberHashcode.toString() == Prefs.getId)
                              SizedBox(height: 12),

                            if (job.memberHashcode.toString() == Prefs.getId)
                              Obx(
                                () => controller.isUpdatingStatus.value
                                    ? Center(
                                        child: ProgressBar(
                                          color: context
                                              .resources
                                              .color
                                              .colorPrimary,
                                        ),
                                      )
                                    : job.status != 1
                                    ? PrimaryButton(
                                        title:
                                            context.resources.strings.enableJob,
                                        onPressed: () {
                                          controller.enableJob();
                                        },
                                      )
                                    : PrimaryOutlinedButton(
                                        title: context
                                            .resources
                                            .strings
                                            .disableTask,
                                        onPressed: () {
                                          controller.disableJob();
                                        },
                                      ),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
