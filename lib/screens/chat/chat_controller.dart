import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/ContactsResponse.dart';
import 'package:wazafak_app/model/CoversationsResponse.dart';
import 'package:wazafak_app/model/SupportConversationsResponse.dart';
import 'package:wazafak_app/repository/communication/contacts_repository.dart';
import 'package:wazafak_app/repository/communication/coversations_repository.dart';
import 'package:wazafak_app/repository/support/support_conversations_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class ChatController extends GetxController {
  final ContactsRepository _repository = ContactsRepository();
  final CoversationsRepository _coversationsRepository =
      CoversationsRepository();
  final SupportConversationsRepository _supportConversationsRepository =
      SupportConversationsRepository();

  // Top-level tabs (Chat Conversations vs Support Conversations)
  var selectedTopTab = "".obs;

  // Inner tabs (for Chat Conversations section)
  List<String> get tabs =>
      [
        Resources
            .of(Get.context!)
            .strings
            .ongoingChat,
        Resources
            .of(Get.context!)
            .strings
            .activeEmployers
      ];
  var selectedTab = "".obs;

  // Inner tabs (for Support Conversations section)
  var selectedSupportTab = "".obs;

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

  // Support Conversations data
  var supportConversations = <SupportConversation>[].obs;
  var isLoadingSupportConversations = false.obs;
  var isLoadingMoreSupportConversations = false.obs;
  var hasMoreSupportConversations = true.obs;
  var hasSupportConversationsError = false.obs;
  var supportConversationsErrorMessage = ''.obs;

  // Support Conversations pagination
  var supportConversationsCurrentPage = 1.obs;
  var supportConversationsTotalPages = 1.obs;

  // ScrollController for pagination
  final ScrollController scrollController = ScrollController();
  final ScrollController conversationsScrollController = ScrollController();
  final ScrollController supportConversationsScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // Initialize top-level tab to "Chat Conversations"
    selectedTopTab.value = Resources
        .of(Get.context!)
        .strings
        .chatConversations;
    selectedTab.value = Resources
        .of(Get.context!)
        .strings
        .ongoingChat;
    selectedSupportTab.value = Resources
        .of(Get.context!)
        .strings
        .support;
    _setupScrollListener();
    _setupConversationsScrollListener();
    _setupSupportConversationsScrollListener();
    // Load conversations by default since Ongoing Chat is the default tab
    loadConversations(true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    conversationsScrollController.dispose();
    supportConversationsScrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (selectedTab.value == Resources
          .of(Get.context!)
          .strings
          .activeEmployers &&
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
      if (selectedTab.value == Resources
          .of(Get.context!)
          .strings
          .ongoingChat &&
          conversationsScrollController.position.pixels >=
              conversationsScrollController.position.maxScrollExtent * 0.8) {
        if (!isLoadingMoreConversations.value && hasMoreConversations.value) {
          loadMoreConversations();
        }
      }
    });
  }

  void _setupSupportConversationsScrollListener() {
    supportConversationsScrollController.addListener(() {
      if (selectedTopTab.value == "Support Conversations" &&
          supportConversationsScrollController.position.pixels >=
              supportConversationsScrollController.position.maxScrollExtent * 0.8) {
        if (!isLoadingMoreSupportConversations.value && hasMoreSupportConversations.value) {
          loadMoreSupportConversations();
        }
      }
    });
  }

  void changeTab(String tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;

      // Load data based on selected tab
      if (tab == Resources
          .of(Get.context!)
          .strings
          .activeEmployers && contacts.isEmpty) {
        loadContacts();
      } else if (tab == Resources
          .of(Get.context!)
          .strings
          .ongoingChat && conversations.isEmpty) {
        loadConversations(false);
      }
    }
  }

  Future<void> loadContacts({bool showLoading = true}) async {
    if (isLoading.value) return;

    try {
      if (showLoading) {
        isLoading.value = true;
      }
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
      if (showLoading) {
        isLoading.value = false;
      }
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

  Future<void> refreshContacts({bool showLoading = true}) async {
    if(showLoading) {
      contacts.clear();
    }
    currentPage.value = 1;
    hasMoreData.value = true;
    await loadContacts(showLoading: showLoading);
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

  Future<void> refreshConversations({bool showLoading = true}) async {
    if(showLoading) {
      conversations.clear();
    }
    conversationsCurrentPage.value = 1;
    hasMoreConversations.value = true;
    await loadConversations(showLoading);
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

  // Top-level tab management
  void changeTopTab(String tab) {
    if (selectedTopTab.value != tab) {
      selectedTopTab.value = tab;

      // Load data based on selected top tab
      if (tab == "Support Conversations" && supportConversations.isEmpty) {
        loadSupportConversations(true);
      }
    }
  }

  // Support tab management
  void changeSupportTab(String tab) {
    if (selectedSupportTab.value != tab) {
      selectedSupportTab.value = tab;
      // Reload support conversations with new filter
      loadSupportConversations(true);
    }
  }

  // Support Conversations methods
  Future<void> loadSupportConversations(bool showLoading) async {
    if (isLoadingSupportConversations.value) return;

    try {
      if (showLoading) {
        isLoadingSupportConversations.value = true;
        supportConversations.clear();
      }
      hasSupportConversationsError.value = false;
      supportConversationsErrorMessage.value = '';
      supportConversationsCurrentPage.value = 1;
      hasMoreSupportConversations.value = true;

      // Build filters based on selected support tab
      Map<String, String> filters = {};
      if (selectedSupportTab.value == Resources.of(Get.context!).strings.support) {
        filters['reference'] = 'SUPPORT';
      } else if (selectedSupportTab.value == Resources.of(Get.context!).strings.dispute) {
        filters['reference'] = 'DISPUTE';
      }

      final response = await _supportConversationsRepository.getSupportConversations(
        filters: filters,
      );

      if (response.success == true && response.data != null) {
        supportConversations.value = response.data!.list ?? [];

        if (response.data!.meta != null) {
          supportConversationsCurrentPage.value = response.data!.meta!.page ?? 1;
          supportConversationsTotalPages.value = response.data!.meta!.last ?? 1;
          hasMoreSupportConversations.value =
              supportConversationsCurrentPage.value < supportConversationsTotalPages.value;
        }
      } else {
        hasSupportConversationsError.value = true;
        supportConversationsErrorMessage.value =
            response.message ?? Resources
                .of(Get.context!)
                .strings
                .failedToLoadConversations;
      }
    } catch (e) {
      print('Error loading support conversations: $e');
      hasSupportConversationsError.value = true;
      supportConversationsErrorMessage.value = Resources
          .of(Get.context!)
          .strings
          .failedToLoadConversations;
      Get.snackbar(
        Resources
            .of(Get.context!)
            .strings
            .errorLoadingData(''),
        supportConversationsErrorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingSupportConversations.value = false;
    }
  }

  Future<void> retryLoadSupportConversations() async {
    await loadSupportConversations(true);
  }

  Future<void> loadMoreSupportConversations() async {
    if (isLoadingMoreSupportConversations.value || !hasMoreSupportConversations.value) return;

    try {
      isLoadingMoreSupportConversations.value = true;

      int nextPage = supportConversationsCurrentPage.value + 1;

      // Build filters based on selected support tab
      Map<String, String> filters = {};
      if (selectedSupportTab.value == Resources.of(Get.context!).strings.support) {
        filters['reference'] = 'GENERAL';
      } else if (selectedSupportTab.value == Resources.of(Get.context!).strings.dispute) {
        filters['reference'] = 'DISPUTE';
      }

      final response = await _supportConversationsRepository.getSupportConversations(
        filters: filters,
      );

      if (response.success == true && response.data != null) {
        List<SupportConversation> newConversations = response.data!.list ?? [];
        supportConversations.addAll(newConversations);

        if (response.data!.meta != null) {
          supportConversationsCurrentPage.value =
              response.data!.meta!.page ?? supportConversationsCurrentPage.value;
          supportConversationsTotalPages.value =
              response.data!.meta!.last ?? supportConversationsTotalPages.value;
          hasMoreSupportConversations.value =
              supportConversationsCurrentPage.value < supportConversationsTotalPages.value;
        }
      }
    } catch (e) {
      print('Error loading more support conversations: $e');
    } finally {
      isLoadingMoreSupportConversations.value = false;
    }
  }

  Future<void> refreshSupportConversations({bool showLoading = true}) async {
    if(showLoading) {
      supportConversations.clear();
    }
    supportConversationsCurrentPage.value = 1;
    hasMoreSupportConversations.value = true;
    await loadSupportConversations(showLoading);
  }

  Future<void> refreshAllConversations({bool showLoading = true}) async {
    // Refresh all conversation types in parallel
    await Future.wait([
      refreshConversations(showLoading: showLoading),
      refreshContacts(showLoading: showLoading),
      refreshSupportConversations(showLoading: showLoading),
    ]);
  }

  String getSupportConversationName(SupportConversation conversation) {
    String name = '';
    if (conversation.memberFirstName != null && conversation.memberFirstName!.isNotEmpty) {
      name = conversation.memberFirstName!;
    }
    if (conversation.memberLastName != null && conversation.memberLastName!.isNotEmpty) {
      name += ' ${conversation.memberLastName!}';
    }

    return name
        .trim()
        .isEmpty ? Resources
        .of(Get.context!)
        .strings
        .unknown : name.trim();
  }
}
