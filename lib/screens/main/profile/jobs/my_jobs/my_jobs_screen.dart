import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/skeletons/my_job_item_skeleton.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import 'components/item_my_job.dart';
import 'my_jobs_controller.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyJobsController());

    return FocusDetector(
      onFocusGained: () {
        controller.fetchJobs();
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [
              TopHeader(hasBack: false, title: Resources
                  .of(context)
                  .strings
                  .myJobs),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) => MyJobItemSkeleton(),
                    );
                  }

                  if (controller.jobs.isEmpty) {
                    return Center(child: Text(Resources
                        .of(context)
                        .strings
                        .noJobsAvailable));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.jobs.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final job = controller.jobs[index];
                      return ItemMyJob(
                        job: job,
                        onToggleStatus: () => controller.toggleJobStatus(job),
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: 8),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: PrimaryButton(
                  title: Resources
                      .of(context)
                      .strings
                      .createNewJob,
                  onPressed: () {
                    Get.toNamed(RouteConstant.addJobScreen);
                  },
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
