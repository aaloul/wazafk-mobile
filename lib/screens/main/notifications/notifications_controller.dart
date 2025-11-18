import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/NotificationsResponse.dart';
import 'package:wazafak_app/repository/notification/notifications_list_repository.dart';

class NotificationsController extends GetxController {
  final NotificationsListRepository _repository = NotificationsListRepository();

  // Tabs
  final List<String> tabs = ["All", "Requests", "Payments", "Jobs"];
  var selectedTab = "All".obs;

  // Notifications data
  var notifications = <NotificationElement>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var pageSize = 20.obs;

  // ScrollController for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    loadNotifications();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.8) {
        if (!isLoadingMore.value && hasMoreData.value) {
          loadMoreNotifications();
        }
      }
    });
  }

  void changeTab(String tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;
      resetAndLoadNotifications();
    }
  }

  void resetAndLoadNotifications() {
    notifications.clear();
    currentPage.value = 1;
    hasMoreData.value = true;
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      Map<String, String> filters = {
        'page': currentPage.value.toString(),
        'size': pageSize.value.toString(),
      };

      // Add filter based on selected tab
      if (selectedTab.value != "All") {
        if (selectedTab.value == "Requests") {
          filters['reference'] = "SB,PB,CR";
        } else if (selectedTab.value == "Payments") {
          filters['reference'] = "PA";
        } else if (selectedTab.value == "Jobs") {
          filters['reference'] = "JA";
        }
      }

      final response = await _repository.getNotifications(filters: filters);

      if (response.success == true && response.data != null) {
        notifications.value = response.data!.list ?? [];

        if (response.data!.meta != null) {
          currentPage.value = response.data!.meta!.page ?? 1;
          totalPages.value = response.data!.meta!.last ?? 1;
          hasMoreData.value = currentPage.value < totalPages.value;
        }
      }
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreNotifications() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;

      int nextPage = currentPage.value + 1;

      Map<String, String> filters = {
        'page': nextPage.toString(),
        'size': pageSize.value.toString(),
      };

      // Add filter based on selected tab
      if (selectedTab.value != "All") {
        if (selectedTab.value == "Requests") {
          filters['reference'] = "SB,PB,CR";
        } else if (selectedTab.value == "Payments") {
          filters['reference'] = "PA";
        } else if (selectedTab.value == "Jobs") {
          filters['reference'] = "JA";
        }
      }

      final response = await _repository.getNotifications(filters: filters);

      if (response.success == true && response.data != null) {
        List<NotificationElement> newNotifications = response.data!.list ?? [];
        notifications.addAll(newNotifications);

        if (response.data!.meta != null) {
          currentPage.value = response.data!.meta!.page ?? currentPage.value;
          totalPages.value = response.data!.meta!.last ?? totalPages.value;
          hasMoreData.value = currentPage.value < totalPages.value;
        }
      }
    } catch (e) {
      print('Error loading more notifications: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    notifications.clear();
    currentPage.value = 1;
    hasMoreData.value = true;
    await loadNotifications();
  }

  Future<void> markAsRead(String hashcode) async {
    try {
      // Update UI optimistically
      int index = notifications.indexWhere((n) => n.hashcode == hashcode);
      if (index != -1) {
        notifications[index].isRead = 1;
        notifications.refresh();
      }

      // Call API
      await _repository.markNotificationAsRead(hashcode);
    } catch (e) {
      print('Error marking notification as read: $e');
      // Revert UI change on error
      int index = notifications.indexWhere((n) => n.hashcode == hashcode);
      if (index != -1) {
        notifications[index].isRead = 0;
        notifications.refresh();
      }
    }
  }

  Future<void> markAllAsRead() async {
    try {
      // Update UI optimistically
      for (var notification in notifications) {
        notification.isRead = 1;
      }
      notifications.refresh();

      // Call API
      await _repository.markAllNotificationsAsRead();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      // Reload notifications on error
      refreshNotifications();
    }
  }
}
