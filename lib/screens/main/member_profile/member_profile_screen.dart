import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/member_profile/components/member_profile_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../utils/res/AppIcons.dart';
import 'member_profile_controller.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MemberProfileController());

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
                      text: 'No profile details available',
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MemberProfileHeader(
                        avatar: controller.user.value!.image.toString(),
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
                          text: user.title,
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
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: '${user.nbCompletedJobs ?? '0'}',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: 'Completed Jobs',
                                  fontSize: 14,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 30,
                            color: context.resources.color.colorGrey,
                          ),

                          Expanded(
                            flex: 2,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: '${user.rating}/5',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: 'Rating',
                                  fontSize: 14,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 30,
                            color: context.resources.color.colorGrey,
                          ),

                          Expanded(
                            flex: 3,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: '${user.nbJobPosts ?? '0'}',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  textColor: context.resources.color.colorGrey,
                                ),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: 'Services',
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
                              text: 'About',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                            ),

                            SizedBox(height: 4),

                            PrimaryText(
                              text: user.info ?? "N/A",
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
                                  text: "N/A",
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),

                            SizedBox(height: 6),

                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.calendar,
                                  width: 20,
                                  color: context.resources.color.colorGrey,
                                ),
                                SizedBox(width: 6),
                                PrimaryText(
                                  text: 'Member Since ${user.joinYear}',
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            ),
                            SizedBox(height: 6),

                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.link,
                                  width: 20,
                                  color: context.resources.color.colorGrey,
                                ),
                                SizedBox(width: 6),
                                PrimaryText(
                                  text: user.website ?? 'N/A',
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
                            // Skills Section
                            PrimaryText(
                              text: 'Skills',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              textColor: context.resources.color.colorGrey,
                            ),
                            SizedBox(height: 8),

                            // Check if we have skills
                            Builder(
                              builder: (context) {
                                final skills =
                                    controller.memberProfile.value?.skills;

                                // Debug: Print skills info
                                print(
                                  'Member Profile: ${controller.memberProfile.value != null}',
                                );
                                print('Skills: $skills');
                                print('Skills length: ${skills?.length ?? 0}');

                                if (skills == null || skills.isEmpty) {
                                  return PrimaryText(
                                    text: 'No skills added yet',
                                    fontSize: 14,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  );
                                }

                                return Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: skills.map((skill) {
                                    print('Skill name: ${skill.name}');
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: context
                                              .resources
                                              .color
                                              .colorGrey4,
                                        ),
                                      ),
                                      child: PrimaryText(
                                        text: skill.name ?? 'Unknown',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        textColor:
                                            context.resources.color.colorGrey,
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            SizedBox(height: 16),
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
