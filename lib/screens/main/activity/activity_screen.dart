import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/tabs_widget.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/activity/components/favorite_freelancer_item.dart';
import 'package:wazafak_app/screens/main/projects/components/projects/project_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/progress_bar.dart';
import 'activities_controller.dart';
import 'components/favorite_package_item.dart';
import 'components/favorite_service_item.dart';

class ActivityScreen extends StatelessWidget {
  ActivityScreen({super.key});

  final controller = Get.put(ActivitiesController());

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        // Refresh data when screen gains focus
        controller.refreshCurrentTab();
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [
              TopHeader(
                hasBack: false,
                title: 'Activity',

              ),


              Obx(
                    () =>
                    TabsWidget(
                      tabs: ['Project & Services', 'Pending', 'Pins'],
                      onSelect: (tab) {
                        controller.selectedTab.value = tab;
                      },
                      selectedTab: controller.selectedTab.value,
                    ),
              ),

              Expanded(
                child: Obx(() => _buildTabContent(context)),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    switch (controller.selectedTab.value) {
      case 'Project & Services':
        return _buildOngoingProjects(context);
      case 'Pending':
        return _buildPendingProjects(context);
      case 'Pins':
        return _buildSavedFavorites(context);
      default:
        return Container();
    }
  }

  Widget _buildOngoingProjects(BuildContext context) {
    if (controller.isLoadingEngagements.value) {
      return Center(child: ProgressBar());
    }

    if (controller.ongoingEngagements.isEmpty) {
      return Center(
        child: Text(
          'No ongoing projects',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchOngoingEngagements,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.ongoingEngagements.length,
        itemBuilder: (context, index) {
          final engagement = controller.ongoingEngagements[index];
          return ProjectItem(engagement: engagement,);
        },
      ),
    );
  }

  Widget _buildPendingProjects(BuildContext context) {
    if (controller.isLoadingEngagements.value) {
      return Center(child: ProgressBar());
    }

    if (controller.pendingEngagements.isEmpty) {
      return Center(
        child: Text(
          'No pending projects',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchPendingEngagements,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.pendingEngagements.length,
        itemBuilder: (context, index) {
          final engagement = controller.pendingEngagements[index];
          return ProjectItem(engagement: engagement,);
        },
      ),
    );
  }

  Widget _buildSavedFavorites(BuildContext context) {
    if (controller.isLoadingFavorites.value) {
      return Center(child: ProgressBar());
    }

    if (controller.favorites.isEmpty) {
      return Center(
        child: Text(
          'No saved pins',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchFavoriteJobs,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.favorites.length,
        itemBuilder: (context, index) {
          final favorite = controller.favorites[index];

          // Render different widgets based on entity type
          if (favorite.entityType == 'MEMBER' && favorite.member != null) {
            return FavoriteFreelancerItem(
              freelancer: favorite.member!,
              onFavoriteToggle: controller.toggleMemberFavorite,
            );
          } else
          if (favorite.entityType == 'SERVICE' && favorite.service != null) {
            return FavoriteServiceItem(
              service: favorite.service!,
              onFavoriteToggle: controller.toggleServiceFavorite,
            );
          } else
          if (favorite.entityType == 'PACKAGE' && favorite.package != null) {
            return FavoritePackageItem(
              package: favorite.package!,
              onFavoriteToggle: controller.togglePackageFavorite,
            );
          }

          // Return empty container for unknown types
          return SizedBox.shrink();
        },
      ),
    );
  }



}
