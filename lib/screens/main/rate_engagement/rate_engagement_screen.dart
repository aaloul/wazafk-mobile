import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/rate_engagement/rate_engagement_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../components/multiline_labeled_text_field.dart';
import '../../../utils/res/AppIcons.dart';
import '../member_profiles/components/member_info_header.dart';
import '../member_profiles/components/member_info_widget.dart';
import '../member_profiles/components/member_profile_header.dart';
import '../member_profiles/components/member_skills_widget.dart';

class RateEngagementScreen extends StatelessWidget {
  const RateEngagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RateEngagementController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingProfile.value ||
              controller.isLoadingCriteria.value) {
            return Center(
              child: ProgressBar(color: context.resources.color.colorPrimary),
            );
          }

          if (controller.user.value == null ||
              controller.memberProfile.value == null) {
            return Center(
              child: PrimaryText(
                text: 'Error loading member profile',
                fontSize: 14,
                textColor: context.resources.color.colorGrey,
              ),
            );
          }

          final user = controller.user.value!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Member Profile Header
                      MemberProfileHeader(
                        avatar: user.image.toString(),
                        memberHashcode: user.hashcode ?? '',
                        isFavorite: user.isFavorite ?? false,
                      ),

                      SizedBox(height: 10),
                      // Title
                      Center(
                        child: PrimaryText(
                          text: '${user.firstName} ${user.lastName}',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          textColor: context.resources.color.colorGrey,
                        ),
                      ),

                      // Category
                      Center(
                        child: PrimaryText(
                          text: user.title ?? 'N/A',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey,
                        ),
                      ),

                      SizedBox(height: 20),

                      MemberInfoHeader(
                        memberProfile: controller.memberProfile.value!,
                        isEmployer: controller.targetUserType == 'C',
                      ),

                      Container(
                        width: double.infinity,
                        height: 1,
                        color: context.resources.color.colorGrey
                            .withOpacity(.25),
                        margin: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                      ),

                      MemberInfoWidget(
                        user: controller.memberProfile.value!.member!,
                      ),

                      MemberSkillsWidget(
                        skills:
                        controller.memberProfile.value?.skills ?? [],
                      ),


                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              width: double.infinity,
                              height: 1,
                              color: context.resources.color.colorGrey
                                  .withOpacity(.25),
                              margin: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                            ),

                            // Member Rating Section - only show if not already rated
                            if (controller.engagement.value?.isMemberRated != true) ...[
                              // Member Rating Section
                              _buildSectionTitle(
                                context,
                                controller.targetUserType == 'F'
                                    ? Resources.of(context).strings.rateFreelancer
                                    : Resources.of(context).strings.rateClient,
                              ),

                              SizedBox(height: 10),
                              // Member Criteria Ratings
                              ...controller.memberCriteria.map((criteria) {
                                return _buildRatingItem(
                                  context,
                                  criteria.name ?? '',
                                  criteria.hashcode ?? '',
                                  controller.memberRatings[criteria.hashcode] ??
                                      0.0,
                                  (rating) {
                                    controller.updateMemberRating(
                                      criteria.hashcode ?? '',
                                      rating,
                                    );
                                  },
                                );
                              }).toList(),

                              SizedBox(height: 8),

                              // Member Comment
                              MultilineLabeledTextField(
                                controller: controller.commentController,
                                hint: Resources.of(context).strings.addComment,
                                maxLines: 20,
                                height: 120,
                                inputType: TextInputType.text,
                                isPassword: false,
                                isMandatory: true,
                                label: Resources.of(context).strings.yourReview,
                              ),

                              SizedBox(height: 24),
                            ],

                            // Only show service/job rating if it belongs to the rated member and not already rated
                            if (controller.shouldRateItem &&
                                controller.engagement.value?.isSubjectRated != true) ...[
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: context.resources.color.colorGrey
                                    .withOpacity(.25),
                              ),

                              SizedBox(height: 24),

                              // Service/Job Rating Section
                              _buildSectionTitle(
                                context,
                                controller.itemType == 'J'
                                    ? Resources.of(context).strings.rateJob
                                    : Resources.of(context).strings.rateService,
                              ),
                              SizedBox(height: 4),
                              PrimaryText(
                                text: controller.itemType == 'J'
                                    ? controller.engagement.value?.job?.title ??
                                          ''
                                    : controller
                                              .engagement
                                              .value
                                              ?.services
                                              ?.first
                                              .title ??
                                          '',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorGrey,
                              ),
                              SizedBox(height: 16),

                              // Item Criteria Ratings
                              ...controller.itemCriteria.map((criteria) {
                                return _buildRatingItem(
                                  context,
                                  criteria.name ?? '',
                                  criteria.hashcode ?? '',
                                  controller.itemRatings[criteria.hashcode] ??
                                      0.0,
                                  (rating) {
                                    controller.updateItemRating(
                                      criteria.hashcode ?? '',
                                      rating,
                                    );
                                  },
                                );
                              }).toList(),

                              SizedBox(height: 8),

                              // Item Comment
                              MultilineLabeledTextField(
                                controller: controller.itemCommentController,
                                hint: Resources.of(context).strings.addComment,
                                maxLines: 20,
                                height: 120,
                                inputType: TextInputType.text,
                                isPassword: false,
                                isMandatory: true,
                                label: Resources.of(context).strings.yourReview,
                              ),

                              SizedBox(height: 24),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Submit Button
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.resources.color.colorWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Obx(() {
                  if (controller.isSubmittingRating.value) {
                    return Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.resources.color.colorPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: context.resources.color.colorWhite,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  }

                  return PrimaryButton(
                    title: Resources.of(context).strings.submitRating,
                    onPressed: controller.submitRating,
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return PrimaryText(
      text: title,
      fontSize: 18,
      fontWeight: FontWeight.w900,
      textColor: context.resources.color.colorGrey,
    );
  }

  Widget _buildRatingItem(
    BuildContext context,
    String title,
    String criteriaHashcode,
    double currentRating,
    Function(double) onRatingUpdate,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            textColor: context.resources.color.colorGrey,
          ),

          SizedBox(height: 6),

          RatingBar.builder(
            initialRating: 0.0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 26.0,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            unratedColor: context.resources.color.colorGrey2,
            itemBuilder: (context, index) => Image.asset(
              AppIcons.star,
              color: context.resources.color.colorPrimary,
            ),
            onRatingUpdate: onRatingUpdate,
          ),
        ],
      ),
    );
  }
}
