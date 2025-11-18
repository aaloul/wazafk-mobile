import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/all_jobs/all_jobs_controller.dart';
import 'package:wazafak_app/screens/main/all_jobs/components/all_jobs_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

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
            TopHeader(hasBack: true, title: 'All Jobs'),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.jobs.isEmpty) {
                  return Center(child: ProgressBar());
                }

                if (controller.jobs.isEmpty && !controller.isLoading.value) {
                  return Center(
                    child: Text(
                      'No jobs available',
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
                      itemCount:
                          controller.jobs.length +
                          (controller.hasMore.value &&
                                  controller.isLoadingMore.value
                              ? 1
                              : 0),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == controller.jobs.length) {
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

                        final job = controller.jobs[index];
                        return AllJobsItem(
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
