import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_freelancer_item.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_package_item.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_service_item.dart';
import 'package:wazafak_app/screens/main/home/components/skeletons/home_freelancer_skeleton.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../all_employer_data_controller.dart';

class EmployerDataListWidget extends StatelessWidget {
  const EmployerDataListWidget({super.key, required this.controller});

  final AllEmployerDataController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.employerData.isEmpty) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: 5,
          itemBuilder: (context, index) => HomeFreelancerSkeleton(),
        );
      }

      if (controller.employerData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_search,
                size: 64,
                color: context.resources.color.colorGrey3,
              ),
              SizedBox(height: 16),
              PrimaryText(
                text: "No data available",
                fontSize: 16,
                textColor: context.resources.color.colorGrey3,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 8),
              PrimaryText(
                text: "Try changing the filter or check back later",
                fontSize: 14,
                textColor: context.resources.color.colorGrey3,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        color: context.resources.color.colorPrimary,
        child: ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount:
              controller.employerData.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.employerData.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ProgressBar(
                    color: context.resources.color.colorPrimary,
                  ),
                ),
              );
            }

            final data = controller.employerData[index];

            // Render different widgets based on entity type
            if (data.entityType == 'MEMBER' && data.member != null) {
              return HomeFreelancerItem(
                freelancer: data.member!,
                onFavoriteToggle: controller.toggleMemberFavorite,
              );
            } else if (data.entityType == 'SERVICE' && data.service != null) {
              return HomeServiceItem(
                service: data.service!,
                onFavoriteToggle: controller.toggleServiceFavorite,
              );
            } else if (data.entityType == 'PACKAGE' && data.package != null) {
              return HomePackageItem(
                package: data.package!,
                onFavoriteToggle: controller.togglePackageFavorite,
              );
            }

            // Return empty container for unknown types
            return SizedBox.shrink();
          },
        ),
      );
    });
  }
}
