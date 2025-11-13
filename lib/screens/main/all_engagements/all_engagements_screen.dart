import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/all_engagements/all_engagements_controller.dart';
import 'package:wazafak_app/screens/main/all_engagements/components/all_engagements_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class AllEngagementsScreen extends StatelessWidget {
  const AllEngagementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllEngagementsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'All Engagements'),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.engagements.isEmpty) {
                  return Center(child: ProgressBar());
                }

                if (controller.engagements.isEmpty &&
                    !controller.isLoading.value) {
                  return Center(
                    child: Text(
                      'No engagements available',
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
                          controller.engagements.length +
                          (controller.hasMore.value &&
                                  controller.isLoadingMore.value
                              ? 1
                              : 0),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == controller.engagements.length) {
                          // Small loading indicator at the bottom for pagination
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        }

                        final engagement = controller.engagements[index];
                        return AllEngagementsItem(engagement: engagement);
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
