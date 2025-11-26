import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/skeletons/job_applicant_item_skeleton.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/job_applicants/components/job_applicant_item.dart';
import 'package:wazafak_app/screens/main/job_applicants/job_applicants_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class JobApplicantsScreen extends StatelessWidget {
  const JobApplicantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobApplicantsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Freelancers Applications'),
            SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) => JobApplicantItemSkeleton(),
                  );
                }

                if (controller.applicants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: context.resources.color.colorGrey,
                        ),
                        SizedBox(height: 16),
                        PrimaryText(
                          text: 'No applicants yet',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorGrey,
                        ),
                        SizedBox(height: 8),
                        PrimaryText(
                          text: 'Applications will appear here',
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshApplicants,
                  color: context.resources.color.colorPrimary,
                  child: ListView.separated(
                    itemCount: controller.applicants.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final applicant = controller.applicants[index];
                      return JobApplicantItem(applicantData: applicant);
                    },
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
