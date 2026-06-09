import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/skeletons/project_item_skeleton.dart';
import 'package:wazafak_app/components/tabs_widget.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/projects/components/projects/project_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import 'activities_controller.dart';

class ActivityScreen extends StatelessWidget {
  ActivityScreen({super.key});

  final controller = Get.put(ActivitiesController());

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        // Refresh data when screen gains focus
        controller.fetchOngoingEngagements(isLoading: false);
        controller.fetchPendingEngagements(isLoading: false);
        controller.fetchCompletedEngagements(isLoading: false);
        controller.fetchDisputedEngagements(isLoading: false);
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [
              TopHeader(
                hasBack: false,
                title: Resources
                    .of(context)
                    .strings
                    .activity,

              ),


              SizedBox(height: 16,),

              Obx(
                    () =>
                    TabsWidget(
                      margin: 16,
                      fullWidth: true,
                      tabs: [
                        context.resources.strings.active,
                        context.resources.strings.pending,
                        context.resources.strings.completed,
                        context.resources.strings.dispute
                      ],
                      onSelect: (tab) {
                        controller.selectedTab.value = tab;
                      },
                      selectedTab: controller.selectedTab.value,
                    ),
              ),
              SizedBox(height: 8,),

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
    final strings = Resources.of(context).strings;
    switch (controller.selectedTab.value) {
      case var tab when tab == strings.active:
        return _buildOngoingProjects(context);
      case var tab when tab == strings.pending:
        return _buildPendingProjects(context);
      case var tab when tab == strings.completed:
        return _buildCompletedProjects(context);
      case var tab when tab == strings.dispute:
        return _buildDisputedProjects(context);
      default:
        return Container();
    }
  }

  Widget _buildOngoingProjects(BuildContext context) {
    if (controller.isLoadingEngagements.value) {
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => ProjectItemSkeleton(),
      );
    }

    if (controller.ongoingEngagements.isEmpty) {
      return Center(
        child: Text(
          Resources.of(context).strings.noOngoingProjects,
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
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => ProjectItemSkeleton(),
      );
    }

    if (controller.pendingEngagements.isEmpty) {
      return Center(
        child: Text(
          Resources.of(context).strings.noPendingProjects,
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

  Widget _buildCompletedProjects(BuildContext context) {
    if (controller.isLoadingEngagements.value) {
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => ProjectItemSkeleton(),
      );
    }

    if (controller.completedEngagements.isEmpty) {
      return Center(
        child: Text(
          Resources.of(context).strings.noCompletedProjects,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchCompletedEngagements,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.completedEngagements.length,
        itemBuilder: (context, index) {
          final engagement = controller.completedEngagements[index];
          return ProjectItem(engagement: engagement,);
        },
      ),
    );
  }

  Widget _buildDisputedProjects(BuildContext context) {
    if (controller.isLoadingEngagements.value) {
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => ProjectItemSkeleton(),
      );
    }

    if (controller.disputedEngagements.isEmpty) {
      return Center(
        child: Text(
          Resources.of(context).strings.noDisputedProjects,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchDisputedEngagements,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.disputedEngagements.length,
        itemBuilder: (context, index) {
          final engagement = controller.disputedEngagements[index];
          return ProjectItem(engagement: engagement,);
        },
      ),
    );
  }



}
