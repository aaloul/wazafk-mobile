import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/skeletons/notification_item_skeleton.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../notifications_controller.dart';
import 'notification_details_sheet.dart';
import 'notification_item.dart';

class NotificationsListWidget extends StatelessWidget {
  const NotificationsListWidget({super.key, required this.controller});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.notifications.isEmpty) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: 5,
          itemBuilder: (context, index) => NotificationItemSkeleton(),
        );
      }

      if (controller.notifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                size: 64,
                color: context.resources.color.colorGrey3,
              ),
              SizedBox(height: 16),
              PrimaryText(
                text: context.resources.strings.noNotificationsYet,
                fontSize: 16,
                textColor: context.resources.color.colorGrey3,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 8),
              PrimaryText(
                text: context.resources.strings.notificationsDescription,
                fontSize: 14,
                textColor: context.resources.color.colorGrey3,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshNotifications,
        color: context.resources.color.colorPrimary,
        child: ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount:
              controller.notifications.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.notifications.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ProgressBar(
                    color: context.resources.color.colorPrimary,
                  ),
                ),
              );
            }

            final notification = controller.notifications[index];
            return NotificationItem(
              notification: notification,
              onTap: () {
                NotificationDetailsSheet.show(
                  context,
                  notification: notification,
                  onMarkAsRead: () {
                    controller.markAsRead(notification.hashcode ?? '');
                  },
                );
              },
            );
          },
        ),
      );
    });
  }
}
