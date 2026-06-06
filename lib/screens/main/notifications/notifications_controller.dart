import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/NotificationsResponse.dart';
import 'package:wazafak_app/repository/engagement/accept_reject_engagement_repository.dart';
import 'package:wazafak_app/repository/notification/notifications_list_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/strings/Strings.dart';
import 'package:wazafak_app/utils/utils.dart';

/// Notification categories — value mirrors API `category` param.
/// API contract (per Postman): Hiring | Payments | Account | Jobs | Earnings
enum NotificationCategory { all, hiring, payments, jobs, earnings, account }

/// Sub-categories — value mirrors API `sub_category` param.
/// API contract: HiringUpdates | ActiveJobs | WorkRequests | Opportunities
enum NotificationSubCategory {
  hiringUpdates,
  activeJobs,
  workRequests,
  opportunities,
}

extension NotificationCategoryApi on NotificationCategory {
  /// Value sent to the API. `all` sends nothing.
  String? get apiValue {
    switch (this) {
      case NotificationCategory.all:
        return null;
      case NotificationCategory.hiring:
        return 'Hiring';
      case NotificationCategory.payments:
        return 'Payments';
      case NotificationCategory.jobs:
        return 'Jobs';
      case NotificationCategory.earnings:
        return 'Earnings';
      case NotificationCategory.account:
        return 'Account';
    }
  }

  String label(Strings strings) {
    switch (this) {
      case NotificationCategory.all:
        return strings.all;
      case NotificationCategory.hiring:
        return strings.hiring;
      case NotificationCategory.payments:
        return strings.payments;
      case NotificationCategory.jobs:
        return strings.jobs;
      case NotificationCategory.earnings:
        return strings.earnings;
      case NotificationCategory.account:
        return strings.account;
    }
  }
}

extension NotificationSubCategoryApi on NotificationSubCategory {
  String get apiValue {
    switch (this) {
      case NotificationSubCategory.hiringUpdates:
        return 'HiringUpdates';
      case NotificationSubCategory.activeJobs:
        return 'ActiveJobs';
      case NotificationSubCategory.workRequests:
        return 'WorkRequests';
      case NotificationSubCategory.opportunities:
        return 'Opportunities';
    }
  }

  String label(Strings strings) {
    switch (this) {
      case NotificationSubCategory.hiringUpdates:
        return strings.hiringUpdates;
      case NotificationSubCategory.activeJobs:
        return strings.activeJobs.replaceAll('\n', ' ');
      case NotificationSubCategory.workRequests:
        return strings.workRequests;
      case NotificationSubCategory.opportunities:
        return strings.opportunities;
    }
  }
}

class NotificationsController extends GetxController {
  final NotificationsListRepository _repository = NotificationsListRepository();
  final AcceptRejectEngagementRepository _acceptRejectRepository =
      AcceptRejectEngagementRepository();

  /// Reference codes that indicate an actionable booking request.
  static const _bookingReferenceCodes = {'SB', 'PB'};
  static const _approveRejectActionCode = 'APPROVE_REJECT';

  /// True if the notification is a booking request awaiting accept/decline.
  bool isActionableBookingRequest(NotificationElement n) {
    final ref = n.reference?.toString();
    final action = n.actionCode?.toString();
    return action == _approveRejectActionCode &&
        ref != null &&
        _bookingReferenceCodes.contains(ref) &&
        (n.referenceHashcode?.toString().isNotEmpty ?? false);
  }

  /// Hashcodes of notifications currently being accepted/declined.
  final processingHashcodes = <String>{}.obs;

  bool isProcessing(NotificationElement n) =>
      n.hashcode != null && processingHashcodes.contains(n.hashcode);

  /// 'C' for client/employer, 'F' for freelancer. Matches API `profile` param.
  String get profile => Prefs.getUserMode == 'freelancer' ? 'F' : 'C';

  bool get isFreelancer => profile == 'F';

  List<NotificationCategory> get categories => isFreelancer
      ? const [
          NotificationCategory.all,
          NotificationCategory.jobs,
          NotificationCategory.earnings,
          NotificationCategory.account,
        ]
      : const [
          NotificationCategory.all,
          NotificationCategory.hiring,
          NotificationCategory.payments,
          NotificationCategory.account,
        ];

  /// Sub-categories shown when the given category is selected. Empty = no chips.
  List<NotificationSubCategory> subCategoriesFor(NotificationCategory cat) {
    if (cat == NotificationCategory.hiring) {
      return const [
        NotificationSubCategory.hiringUpdates,
        NotificationSubCategory.activeJobs,
      ];
    }
    if (cat == NotificationCategory.jobs) {
      return const [
        NotificationSubCategory.workRequests,
        NotificationSubCategory.activeJobs,
        NotificationSubCategory.opportunities,
      ];
    }
    return const [];
  }

  var selectedCategory = NotificationCategory.all.obs;
  var selectedSubCategory = Rxn<NotificationSubCategory>();

  // Notifications data
  var notifications = <NotificationElement>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var pageSize = 20.obs;

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

  void changeCategory(NotificationCategory category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    selectedSubCategory.value = null;
    resetAndLoadNotifications();
  }

  void changeSubCategory(NotificationSubCategory? subCategory) {
    if (selectedSubCategory.value == subCategory) return;
    selectedSubCategory.value = subCategory;
    resetAndLoadNotifications();
  }

  void resetAndLoadNotifications() {
    notifications.clear();
    currentPage.value = 1;
    hasMoreData.value = true;
    loadNotifications();
  }

  Map<String, String> _buildFilters(int page) {
    final filters = <String, String>{
      'page': page.toString(),
      'size': pageSize.value.toString(),
      'profile': profile,
    };
    final cat = selectedCategory.value.apiValue;
    if (cat != null) filters['category'] = cat;
    final sub = selectedSubCategory.value?.apiValue;
    if (sub != null) filters['sub_category'] = sub;
    return filters;
  }

  Future<void> loadNotifications() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await _repository.getNotifications(
        filters: _buildFilters(currentPage.value),
      );

      if (response.success == true && response.data != null) {
        notifications.value = response.data!.list ?? [];

        if (response.data!.meta != null) {
          currentPage.value = response.data!.meta!.page ?? 1;
          totalPages.value = response.data!.meta!.last ?? 1;
          hasMoreData.value = currentPage.value < totalPages.value;
        }
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreNotifications() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;
      final nextPage = currentPage.value + 1;
      final response = await _repository.getNotifications(
        filters: _buildFilters(nextPage),
      );

      if (response.success == true && response.data != null) {
        notifications.addAll(response.data!.list ?? []);

        if (response.data!.meta != null) {
          currentPage.value = response.data!.meta!.page ?? currentPage.value;
          totalPages.value = response.data!.meta!.last ?? totalPages.value;
          hasMoreData.value = currentPage.value < totalPages.value;
        }
      }
    } catch (e) {
      debugPrint('Error loading more notifications: $e');
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
      final index = notifications.indexWhere((n) => n.hashcode == hashcode);
      if (index != -1) {
        notifications[index].isRead = 1;
        notifications.refresh();
      }
      await _repository.markNotificationAsRead(hashcode);
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      final index = notifications.indexWhere((n) => n.hashcode == hashcode);
      if (index != -1) {
        notifications[index].isRead = 0;
        notifications.refresh();
      }
    }
  }

  Future<void> acceptBookingRequest(NotificationElement notification) =>
      _respondToBookingRequest(notification, accept: true);

  Future<void> declineBookingRequest(NotificationElement notification) =>
      _respondToBookingRequest(notification, accept: false);

  Future<void> _respondToBookingRequest(
    NotificationElement notification, {
    required bool accept,
  }) async {
    final hashcode = notification.hashcode;
    final engagementHashcode = notification.referenceHashcode?.toString();
    if (hashcode == null ||
        engagementHashcode == null ||
        engagementHashcode.isEmpty) {
      return;
    }
    if (processingHashcodes.contains(hashcode)) return;

    final strings = Resources.of(Get.context!).strings;
    processingHashcodes.add(hashcode);

    try {
      final response = await _acceptRejectRepository.acceptRejectEngagement(
        hashcode: engagementHashcode,
        accept: accept,
      );

      if (response.success == true) {
        final index =
            notifications.indexWhere((n) => n.hashcode == hashcode);
        if (index != -1) {
          notifications[index].actionCode = null;
          notifications[index].isRead = 1;
          notifications.refresh();
        }
        constants.showSnackBar(
          accept
              ? strings.taskAcceptedSuccessfully
              : strings.taskRejectedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
      } else {
        constants.showSnackBar(
          response.message ??
              (accept ? strings.failedToAcceptTask : strings.failedToRejectTask),
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      debugPrint('Error responding to booking request: $e');
      constants.showSnackBar(
        accept ? strings.errorAcceptingTask : strings.errorRejectingTask,
        SnackBarStatus.ERROR,
      );
    } finally {
      processingHashcodes.remove(hashcode);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      for (var notification in notifications) {
        notification.isRead = 1;
      }
      notifications.refresh();
      await _repository.markAllNotificationsAsRead();
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      refreshNotifications();
    }
  }

  String categoryLabel(BuildContext context, NotificationCategory c) =>
      c.label(Resources.of(context).strings);

  String subCategoryLabel(
    BuildContext context,
    NotificationSubCategory s,
  ) =>
      s.label(Resources.of(context).strings);
}
