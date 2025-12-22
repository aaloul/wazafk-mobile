import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/ContactsResponse.dart';
import 'package:wazafak_app/model/CoversationsResponse.dart';
import 'package:wazafak_app/repository/communication/contacts_repository.dart';
import 'package:wazafak_app/repository/communication/coversations_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class ChatController extends GetxController {
  final ContactsRepository _repository = ContactsRepository();
  final CoversationsRepository _coversationsRepository =
      CoversationsRepository();

  // Tabs
  final List<String> tabs = ["Ongoing Chat", "Active Employers"];
  var selectedTab = "Ongoing Chat".obs;

  // Contacts data
  var contacts = <ContactElement>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var pageSize = 20.obs;

  // Conversations data
  var conversations = <Coversation>[].obs;
  var isLoadingConversations = false.obs;
  var isLoadingMoreConversations = false.obs;
  var hasMoreConversations = true.obs;
  var hasConversationsError = false.obs;
  var conversationsErrorMessage = ''.obs;

  // Conversations pagination
  var conversationsCurrentPage = 1.obs;
  var conversationsTotalPages = 1.obs;

  // ScrollController for pagination
  final ScrollController scrollController = ScrollController();
  final ScrollController conversationsScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    _setupConversationsScrollListener();
    // Load conversations by default since Ongoing Chat is the default tab
    loadConversations(true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    conversationsScrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (selectedTab.value == "Active Employers" &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.8) {
        if (!isLoadingMore.value && hasMoreData.value) {
          loadMoreContacts();
        }
      }
    });
  }

  void _setupConversationsScrollListener() {
    conversationsScrollController.addListener(() {
      if (selectedTab.value == "Ongoing Chat" &&
          conversationsScrollController.position.pixels >=
              conversationsScrollController.position.maxScrollExtent * 0.8) {
        if (!isLoadingMoreConversations.value && hasMoreConversations.value) {
          loadMoreConversations();
        }
      }
    });
  }

  void changeTab(String tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;

      // Load data based on selected tab
      if (tab == "Active Employers" && contacts.isEmpty) {
        loadContacts();
      } else if (tab == "Ongoing Chat" && conversations.isEmpty) {
        loadConversations(false);
      }
    }
  }

  Future<void> loadContacts() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      currentPage.value = 1;
      contacts.clear();
      hasMoreData.value = true;

      final response = await _repository.getContacts(
        page: currentPage.value,
        size: pageSize.value,
      );

      if (response.success == true && response.data != null) {
        contacts.value = response.data!.list ?? [];

        if (response.data!.meta != null) {
          currentPage.value = response.data!.meta!.page ?? 1;
          totalPages.value = response.data!.meta!.last ?? 1;
          hasMoreData.value = currentPage.value < totalPages.value;
        }
      } else {
        hasError.value = true;
        errorMessage.value = response.message ?? Resources
            .of(Get.context!)
            .strings
            .failedToLoadContacts;
      }
    } catch (e) {
      print('Error loading contacts: $e');
      hasError.value = true;
      errorMessage.value = Resources
          .of(Get.context!)
          .strings
          .failedToLoadContacts;
      Get.snackbar(
        Resources
            .of(Get.context!)
            .strings
            .errorLoadingData(''),
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retryLoadContacts() async {
    await loadContacts();
  }

  Future<void> loadMoreContacts() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;

      int nextPage = currentPage.value + 1;

      final response = await _repository.getContacts(
        page: nextPage,
        size: pageSize.value,
      );

      if (response.success == true && response.data != null) {
        List<ContactElement> newContacts = response.data!.list ?? [];
        contacts.addAll(newContacts);

        if (response.data!.meta != null) {
          currentPage.value = response.data!.meta!.page ?? currentPage.value;
          totalPages.value = response.data!.meta!.last ?? totalPages.value;
          hasMoreData.value = currentPage.value < totalPages.value;
        }
      }
    } catch (e) {
      print('Error loading more contacts: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshContacts() async {
    contacts.clear();
    currentPage.value = 1;
    hasMoreData.value = true;
    await loadContacts();
  }

  String getContactName(ContactElement contact) {
    String name = '';
    if (contact.firstName != null && contact.firstName!.isNotEmpty) {
      name = contact.firstName!;
    }
    if (contact.lastName != null && contact.lastName!.isNotEmpty) {
      name += ' ${contact.lastName!}';
    }

    return name
        .trim()
        .isEmpty ? Resources
        .of(Get.context!)
        .strings
        .unknown : name.trim();
  }

  // Conversations methods
  Future<void> loadConversations(bool showLoading) async {
    if (isLoadingConversations.value) return;

    try {
      if (showLoading) {
        isLoadingConversations.value = true;
        conversations.clear();
      }
      hasConversationsError.value = false;
      conversationsErrorMessage.value = '';
      conversationsCurrentPage.value = 1;
      hasMoreConversations.value = true;

      final response = await _coversationsRepository.getCoversations(
        page: conversationsCurrentPage.value,
        size: pageSize.value,
      );

      if (response.success == true && response.data != null) {
        conversations.value = response.data!.list ?? [];

        if (response.data!.meta != null) {
          conversationsCurrentPage.value = response.data!.meta!.page ?? 1;
          conversationsTotalPages.value = response.data!.meta!.last ?? 1;
          hasMoreConversations.value =
              conversationsCurrentPage.value < conversationsTotalPages.value;
        }
      } else {
        hasConversationsError.value = true;
        conversationsErrorMessage.value =
            response.message ?? Resources
                .of(Get.context!)
                .strings
                .failedToLoadConversations;
      }
    } catch (e) {
      print('Error loading conversations: $e');
      hasConversationsError.value = true;
      conversationsErrorMessage.value = Resources
          .of(Get.context!)
          .strings
          .failedToLoadConversations;
      Get.snackbar(
        Resources
            .of(Get.context!)
            .strings
            .errorLoadingData(''),
        conversationsErrorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingConversations.value = false;
    }
  }

  Future<void> retryLoadConversations() async {
    await loadConversations(true);
  }

  Future<void> loadMoreConversations() async {
    if (isLoadingMoreConversations.value || !hasMoreConversations.value) return;

    try {
      isLoadingMoreConversations.value = true;

      int nextPage = conversationsCurrentPage.value + 1;

      final response = await _coversationsRepository.getCoversations(
        page: nextPage,
        size: pageSize.value,
      );

      if (response.success == true && response.data != null) {
        List<Coversation> newConversations = response.data!.list ?? [];
        conversations.addAll(newConversations);

        if (response.data!.meta != null) {
          conversationsCurrentPage.value =
              response.data!.meta!.page ?? conversationsCurrentPage.value;
          conversationsTotalPages.value =
              response.data!.meta!.last ?? conversationsTotalPages.value;
          hasMoreConversations.value =
              conversationsCurrentPage.value < conversationsTotalPages.value;
        }
      }
    } catch (e) {
      print('Error loading more conversations: $e');
    } finally {
      isLoadingMoreConversations.value = false;
    }
  }

  Future<void> refreshConversations() async {
    conversations.clear();
    conversationsCurrentPage.value = 1;
    hasMoreConversations.value = true;
    await loadConversations(true);
  }

  String getConversationName(Coversation conversation) {
    String name = '';
    if (conversation.firstName != null && conversation.firstName!.isNotEmpty) {
      name = conversation.firstName!;
    }
    if (conversation.lastName != null && conversation.lastName!.isNotEmpty) {
      name += ' ${conversation.lastName!}';
    }

    return name
        .trim()
        .isEmpty ? Resources
        .of(Get.context!)
        .strings
        .unknown : name.trim();
  }

  String formatLastMessageTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return Resources
            .of(Get.context!)
            .strings
            .yesterday;
      } else if (difference.inDays < 7) {
        return Resources
            .of(Get.context!)
            .strings
            .daysAgo(difference.inDays);
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } else if (difference.inHours > 0) {
      return Resources
          .of(Get.context!)
          .strings
          .hoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return Resources
          .of(Get.context!)
          .strings
          .minutesAgo(difference.inMinutes);
    } else {
      return Resources
          .of(Get.context!)
          .strings
          .justNow;
    }
  }
}
