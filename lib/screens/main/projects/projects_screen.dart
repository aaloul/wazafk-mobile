import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/skeletons/project_item_skeleton.dart';
import 'package:wazafak_app/screens/main/projects/projects_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../components/search_widget.dart';
import '../../../components/tabs_widget.dart';
import '../../../constants/route_constant.dart';
import '../../../utils/res/AppIcons.dart';
import '../home/components/employer_data/home_service_item.dart';
import 'components/jobs/projects_job_item.dart';
import 'components/projects/project_item.dart';
import 'components/projects/saved_package_item.dart';

class ProjectsScreen extends StatelessWidget {
  ProjectsScreen({super.key});


  final controller = Get.put(ProjectsController());


  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        // Refresh data when screen gains focus
        controller.fetchOngoingEngagements(isLoading: false);
        controller.fetchPendingEngagements(isLoading: false);
        controller.fetchCompletedEngagements(isLoading: false);
        controller.fetchDisputedEngagements(isLoading: false);
        controller.fetchSavedItems(isLoading: false);
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [

          Container(
              decoration: BoxDecoration(
                color: context.resources.color.colorWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
            child: Column(
              children: [
                SizedBox(height: 16,),

                SizedBox(
                  height: 44,
                  child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: PrimaryText(
                        text: Resources.of(context).strings.projects,
                        textColor: context.resources.color.colorBlack4,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Positioned(
                      right: 16,
                      child: GestureDetector(
                        onTap: () =>
                            Get.toNamed(RouteConstant.calendarScreen),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.resources.color.colorWhite,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.resources.color.colorGrey4,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              AppIcons.calendar,
                              width: 20,
                              color: context.resources.color.colorPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ),

                SizedBox(height: 16,),

                Obx(
                      () =>
                      TabsWidget(
                        tabs: [
                          context.resources.strings.active,
                          context.resources.strings.pending,
                          context.resources.strings.completed,
                          context.resources.strings.dispute,
                          context.resources.strings.saved
                        ],
                        onSelect: (tab) {
                          controller.selectedTab.value = tab;
                        },
                        selectedTab: controller.selectedTab.value,
                        margin: 10,
                      ),
                ),
                SizedBox(height: 16,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SearchWidget(
                    borderRadius: 12,
                    height: 45,
                    onTextChanged: (v) => controller.searchQuery.value = v,
                  ),
                ),

                SizedBox(height: 16,),

              ],
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
      case var tab when tab == strings.saved:
        return _buildSaved(context);
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

    final items = controller.filterEngagements(controller.ongoingEngagements);
    if (items.isEmpty) {
      return Center(
        child: Text(
          context.resources.strings.noOngoingProjects,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchOngoingEngagements,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final engagement = items[index];
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

    final items = controller.filterEngagements(controller.pendingEngagements);
    if (items.isEmpty) {
      return Center(
        child: Text(
          context.resources.strings.noPendingProjects,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchPendingEngagements,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final engagement = items[index];
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

    final items = controller.filterEngagements(controller.completedEngagements);
    if (items.isEmpty) {
      return Center(
        child: Text(
          context.resources.strings.noCompletedProjects,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchCompletedEngagements,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final engagement = items[index];
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

    final items = controller.filterEngagements(controller.disputedEngagements);
    if (items.isEmpty) {
      return Center(
        child: Text(
          context.resources.strings.noDisputedProjects,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchDisputedEngagements,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final engagement = items[index];
          return ProjectItem(engagement: engagement);
        },
      ),
    );
  }

  Widget _buildSaved(BuildContext context) {
    if (controller.isLoadingFavorites.value) {
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => ProjectItemSkeleton(),
      );
    }

    if (controller.favorites.isEmpty) {
      return Center(
        child: Text(context.resources.strings.noSavedItems),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchSavedItems,
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: controller.favorites.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final fav = controller.favorites[index];
          if (fav.job != null) {
            return Obx(
              () => ProjectsJobItem(
                job: fav.job!,
                onFavoriteToggle: controller.toggleJobFavorite,
                isRemoving: controller.removingFavoriteHashcode.value ==
                    fav.job!.hashcode,
              ),
            );
          }
          if (fav.service != null) {
            return HomeServiceItem(
              service: fav.service!,
              onFavoriteToggle: controller.toggleServiceFavorite,
            );
          }
          if (fav.package != null) {
            return SavedPackageItem(
              package: fav.package!,
              onFavoriteToggle: controller.togglePackageFavorite,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
