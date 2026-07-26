import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/search_widget.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/components/skeletons/job_item_skeleton.dart';
import 'package:wazafak_app/screens/main/all_jobs/all_jobs_controller.dart';
import 'package:wazafak_app/screens/main/home/components/jobs/home_job_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

class AllJobsScreen extends StatelessWidget {
  const AllJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllJobsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8),
            _JobsSearchHeader(controller: controller),
            SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.jobs.isEmpty) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: 5,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemBuilder: (context, index) => JobItemSkeleton(),
                  );
                }

                final jobs = controller.visibleJobs;

                if (jobs.isEmpty && !controller.isLoading.value) {
                  return Center(
                    child: Text(
                      context.resources.strings.noJobsAvailable,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.resources.color.colorGrey14,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          controller.hasMore.value &&
                          !controller.isLoadingMore.value) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: jobs.length +
                          (controller.hasMore.value &&
                                  controller.isLoadingMore.value
                              ? 1
                              : 0),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == jobs.length) {
                          // Small loading indicator at the bottom for pagination
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: ProgressBar(),
                              ),
                            ),
                          );
                        }

                        final job = jobs[index];
                        return HomeJobItem(
                          job: job,
                          onFavoriteToggle: controller.toggleJobFavorite,
                        );
                      },
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

/// Back button, "Search for job" field and the filter button (design p46).
class _JobsSearchHeader extends StatelessWidget {
  const _JobsSearchHeader({required this.controller});

  final AllJobsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: RotatedBox(
              quarterTurns: Utils().isRTL() ? 2 : 0,
              child: Image.asset(AppIcons.back3, width: 40),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SearchWidget(
              controller: controller.searchController,
              hint: controller.screenTitle ??
                  Resources.of(context).strings.searchForJob,
              borderRadius: 12,
              height: 40,
              margin: 0,
              onTextChanged: controller.onSearchChanged,
              enabled: true,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => SheetHelper.showFilterSheet(
              context,
              initialFilters: controller.activeFilters.value.copy(),
              onApply: controller.applyFilters,
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.resources.color.colorPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                AppIcons.filter,
                width: 20,
                color: context.resources.color.colorWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
