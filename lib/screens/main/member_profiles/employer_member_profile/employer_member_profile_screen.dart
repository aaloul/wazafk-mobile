import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/member_profiles/components/jobs/member_jobs_carousel.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../components/employer_profile_header.dart';
import '../components/member_info_widget.dart';
import '../components/member_rating_info.dart';
import 'employer_member_profile_controller.dart';

class EmployerMemberProfileScreen extends StatelessWidget {
  const EmployerMemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployerMemberProfileController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: ProgressBar());
                }

                final user = controller.user.value;
                if (user == null) {
                  return Center(
                    child: PrimaryText(
                      text: context.resources.strings.noProfileDetailsAvailable,
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmployerProfileHeader(user: controller.user.value!),

                        SizedBox(height: 10),

                        MemberInfoWidget(
                          user: controller.memberProfile.value!.member!,
                        ),

                        MemberRatingInfo(
                          memberProfile: controller.memberProfile.value!,
                        ),

                        MemberJobsCarousel(
                          engagements: controller.engagements,
                          isLoading: controller.isLoadingEngagements.value,
                          title: context.resources.strings.hiringHistory,
                        ),

                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              }),
            ),

            // Pinned "View Job Posts" action (design p45) — opens this
            // employer's posts.
            Obx(() {
              final user = controller.user.value;
              if (controller.isLoading.value || user == null) {
                return SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: PrimaryButton(
                  title: context.resources.strings.viewJobPosts,
                  onPressed: () => Get.toNamed(
                    RouteConstant.allJobsScreen,
                    arguments: {
                      'member': user.hashcode,
                      'title': [
                        user.firstName ?? '',
                        user.lastName ?? '',
                      ].join(' ').trim(),
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
