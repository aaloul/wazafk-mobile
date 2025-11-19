import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/ContactsResponse.dart';
import 'package:wazafak_app/repository/communication/contacts_repository.dart';

class ChatController extends GetxController {
  final ContactsRepository _repository = ContactsRepository();

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

  // ScrollController for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
  }

  @override
  void onClose() {
    scrollController.dispose();
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

  void changeTab(String tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;

      // Load contacts when switching to Active Employers tab
      if (tab == "Active Employers" && contacts.isEmpty) {
        loadContacts();
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
        errorMessage.value = response.message ?? 'Failed to load contacts';
      }
    } catch (e) {
      print('Error loading contacts: $e');
      hasError.value = true;
      errorMessage.value =
          'Failed to load contacts. Please check your connection.';
      Get.snackbar(
        'Error',
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

    return name.trim().isEmpty ? 'Unknown' : name.trim();
  }
}
