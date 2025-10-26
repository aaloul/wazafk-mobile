import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../components/member_info_header.dart';
import '../components/member_profile_header.dart';
import '../components/member_rating_info.dart';
import 'employer_rate_member_controller.dart';

class EmployerRateMemberScreen extends StatelessWidget {
  const EmployerRateMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployerRateMemberController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoadingCriteria.value) {
                  return Center(child: ProgressBar());
                }

                if (controller.criteria.isEmpty) {
                  return Center(
                    child: PrimaryText(
                      text: 'No rating criteria available',
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MemberProfileHeader(
                            avatar: controller.memberImage.toString(),
                          ),

                          SizedBox(height: 10),

                          // Title
                          Center(
                            child: PrimaryText(
                              text: controller.memberName.toString(),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                            ),
                          ),

                          Center(
                            child: PrimaryText(
                              text: controller.memberProfile.value?.member
                                  ?.title ?? "N/A",
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey,
                            ),
                          ),
                          SizedBox(height: 20),

                          Obx(() =>
                          controller.isLoadingProfile.value
                              ? Container()
                              : MemberInfoHeader(
                            memberProfile: controller.memberProfile.value!,),),

                          Container(
                            width: double.infinity,
                            height: 1,
                            color: context.resources.color.colorGrey
                                .withOpacity(
                              .25,
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                          ),


                          // Member Ratings Display
                          Obx(() {
                            if (controller.isLoadingProfile.value) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: Center(child: ProgressBar()),
                              );
                            }

                            return MemberRatingInfo(
                              memberProfile: controller.memberProfile.value!,);
                          }),

                          Container(
                            width: double.infinity,
                            height: 1,
                            color: context.resources.color.colorGrey
                                .withOpacity(
                              .25,
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                          ),



                          // Rating Criteria List
                          Obx(() {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: List.generate(
                                  controller.criteria.length,
                                  (index) {
                                    final criterion =
                                        controller.criteria[index];
                                    final currentRating = controller
                                        .getCriterionRating(
                                          criterion.hashcode ?? '',
                                        );

                                    return Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PrimaryText(
                                            text: criterion.name ?? 'N/A',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey,
                                          ),
                                          SizedBox(height: 12),
                                          RatingBar.builder(
                                            initialRating: currentRating,
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemSize: 28.0,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 2.0,
                                                ),
                                            unratedColor: context
                                                .resources
                                                .color
                                                .colorGrey9,
                                            itemBuilder: (context, index) =>
                                                Image.asset(
                                                  AppIcons.star,
                                                  color: context
                                                      .resources
                                                      .color
                                                      .colorPrimary,
                                                ),
                                            onRatingUpdate: (rating) {
                                              controller.updateCriterionRating(
                                                criterion.hashcode ?? '',
                                                rating,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),

                          SizedBox(height: 8),

                          // Comment Section
                          MultilineLabeledTextField(
                            controller: controller.commentController,
                            label: 'Your Review',
                            hint: 'Add your feedback',
                            maxLines: 10,
                            height: 120,
                            labelFontSize: 14,
                            labelFontWeight: FontWeight.w400,
                            inputType: TextInputType.text,
                            isPassword: false,
                            isMandatory: true,
                          ),

                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            // Submit Button
            Obx(
              () => controller.isSubmitting.value
                  ? ProgressBar()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: PrimaryButton(
                        title: "Submit Rating",
                        onPressed: () {
                          controller.submitRating();
                        },
                      ),
                    ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
