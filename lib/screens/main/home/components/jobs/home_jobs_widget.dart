import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../skeletons/home_job_skeleton.dart';
import 'home_job_item.dart';

class HomeJobsWidget extends StatelessWidget {
  const HomeJobsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryText(
                  text: context.resources.strings.availableJobs,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteConstant.allJobsScreen);
                },
                child: PrimaryText(
                  text: context.resources.strings.viewAll,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorGrey14,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.isLoadingJobs.value && controller.jobs.isEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) => HomeJobSkeleton(),
              );
            }

            if (controller.jobs.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(child: Text(Resources
                    .of(context)
                    .strings
                    .noJobsAvailable)),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.jobs.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final job = controller.jobs[index];
                return HomeJobItem(
                  job: job,
                  onFavoriteToggle: controller.toggleJobFavorite,
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
