import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/projects/projects_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/tabs_widget.dart';
import 'components/jobs/projects_job_item.dart';
import 'components/projects/project_item.dart';

class ProjectsScreen extends StatelessWidget {
  ProjectsScreen({super.key});


  final controller = Get.put(ProjectsController());


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
                title: 'Projects',

              ),


              Obx(
                    () =>
                    TabsWidget(
                      tabs: ['Ongoing Project', 'Pending', 'Saved Jobs'],
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
      case 'Ongoing Project':
        return _buildOngoingProjects(context);
      case 'Pending':
        return _buildPendingProjects(context);
      case 'Saved Jobs':
        return _buildSavedJobs(context);
      default:
        return Container();
    }
  }

  Widget _buildOngoingProjects(BuildContext context) {
    if (controller.isLoadingEngagements.value) {
      return Center(child: CircularProgressIndicator());
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
      return Center(child: CircularProgressIndicator());
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

  Widget _buildSavedJobs(BuildContext context) {
    if (controller.isLoadingFavorites.value) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.favorites.isEmpty) {
      return Center(
        child: Text(
          'No saved jobs',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchFavoriteJobs,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.favorites.length,
        itemBuilder: (context, index) {
          final job = controller.favorites[index].job!;
          return ProjectsJobItem(job: job,);
        },
      ),
    );
  }


}
