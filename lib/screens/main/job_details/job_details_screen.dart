import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/outlined_button.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/job_details/job_details_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
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
      backgroundColor: context.resources.color.background,
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

                      // Title
                      Center(
                        child: PrimaryText(
                          text: job.title ?? '',
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w900,
                          textColor: context.resources.color.colorGrey,
                        ),
                      ),

                      // Category
                      if (job.categoryName != null)
                        Center(
                          child: PrimaryText(
                            text: job.parentCategoryName != null
                                ? "${job.parentCategoryName} / ${job.categoryName}"
                                : job.categoryName.toString(),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            textColor: context.resources.color.colorGrey,
                          ),
                        ),

                      SizedBox(height: 20),

                      // Price Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: '${job.nbApplicants}',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: context.resources.strings.applicants,
                                  fontSize: 14,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 1.5,
                            height: 30,
                            color: context.resources.color.colorGrey,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: '\$${job.totalPrice}',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: context.resources.strings.totalPrice,
                                  fontSize: 14,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Container(
                        width: double.infinity,
                        height: 1,
                        color: context.resources.color.colorGrey.withOpacity(
                          .25,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: context.resources.strings.overview,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 4),

                            PrimaryText(
                              text:
                                  job.overview ??
                                  context.resources.strings.notAvailable,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 16),

                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.location,
                                  width: 20,
                                  color: context.resources.color.colorGrey,
                                ),
                                SizedBox(width: 6),
                                PrimaryText(
                                  text:
                                      job.address?.city ??
                                      context.resources.strings.notAvailable,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),

                            SizedBox(height: 4),

                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.calendar,
                                  width: 20,
                                  color: context.resources.color.colorGrey,
                                ),
                                SizedBox(width: 6),
                                PrimaryText(
                                  text: DateFormat(
                                    'dd-MM-yyyy hh:mm a',
                                  ).format(job.startDatetime!),
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        height: 1,
                        color: context.resources.color.colorGrey.withOpacity(
                          .25,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Skills
                            if (job.skills != null &&
                                job.skills!.isNotEmpty) ...[
                              PrimaryText(
                                text: context.resources.strings.skills,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                textColor: context.resources.color.colorGrey,
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: job.skills!.map((skill) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color:
                                            context.resources.color.colorGrey4,
                                      ),
                                    ),
                                    child: PrimaryText(
                                      text: skill.name ?? '',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      textColor:
                                          context.resources.color.colorGrey,
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 16),
                            ],

                            PrimaryText(
                              text: context.resources.strings.responsibilities,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 4),

                            PrimaryText(
                              text:
                                  job.responsibilities ??
                                  context.resources.strings.notAvailable,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 16),

                            PrimaryText(
                              text: context.resources.strings.requirements,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 4),

                            PrimaryText(
                              text:
                                  job.requirememts ??
                                  context.resources.strings.notAvailable,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 20),

                            if (job.memberHashcode.toString() != Prefs.getId)
                              // Show View Engagement button if user has an engagement
                              if (job.hasEngagement == 1)
                                PrimaryButton(
                                  title:
                                      context.resources.strings.viewEngagement,
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
