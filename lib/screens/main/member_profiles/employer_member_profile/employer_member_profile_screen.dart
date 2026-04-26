import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../components/member_profile_header.dart';
import '../components/member_rating_info.dart';
import 'employer_member_profile_controller.dart';

class EmployerMemberProfileScreen extends StatelessWidget {
  const EmployerMemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployerMemberProfileController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
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
                      MemberProfileHeader( user: controller.user.value!, isEmployer: true,
                      ),

                      SizedBox(height: 16),



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

                      MemberRatingInfo(
                        memberProfile: controller.memberProfile.value!,
                      ),

                      SizedBox(height: 24),
                    ],
                  ),
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
