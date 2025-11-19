import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/chat/chat_controller.dart';
import 'package:wazafak_app/screens/chat/components/chat_tab_bar.dart';
import 'package:wazafak_app/screens/chat/components/contact_list_item.dart';
import 'package:wazafak_app/screens/chat/components/empty_state_view.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopHeader(title: "Chat"),
            SizedBox(height: 8),
            _buildTabBar(context),
            SizedBox(height: 8),
            Expanded(
              child: Obx(() =>
              controller.selectedTab.value == "Ongoing Chat"
                  ? _buildOngoingChatTab(context)
                  : _buildActiveEmployersTab(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Obx(() =>
        ChatTabBar(
          selectedTab: controller.selectedTab.value,
          onTabSelected: controller.changeTab,
        ));
  }

  Widget _buildOngoingChatTab(BuildContext context) {
    return EmptyStateView(
      message: "No ongoing chats",
      icon: Icons.chat_bubble_outline,
    );
  }

  Widget _buildActiveEmployersTab(BuildContext context) {
    return Obx(() {
      // Loading state
      if (controller.contacts.isEmpty && controller.isLoading.value) {
        return Center(
          child: ProgressBar(
            color: context.resources.color.colorPrimary,
          ),
        );
      }

      // Error state with retry
      if (controller.contacts.isEmpty &&
          !controller.isLoading.value &&
          controller.hasError.value) {
        return EmptyStateView(
          message: controller.errorMessage.value,
          icon: Icons.error_outline,
          showRetry: true,
          onRetry: controller.retryLoadContacts,
        );
      }

      // Empty state
      if (controller.contacts.isEmpty && !controller.isLoading.value) {
        return EmptyStateView(
          message: "No active employers",
          icon: Icons.people_outline,
        );
      }

      // Contacts list
      return RefreshIndicator(
        onRefresh: controller.refreshContacts,
        color: context.resources.color.colorPrimary,
        child: ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.contacts.length +
              (controller.hasMoreData.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.contacts.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ProgressBar(
                    color: context.resources.color.colorPrimary,
                  ),
                ),
              );
            }

            final contact = controller.contacts[index];
            return ContactListItem(
              contact: contact,
              contactName: controller.getContactName(contact),
              onTap: () {
                Get.toNamed(
                  RouteConstant.conversationMessagesScreen,
                  arguments: {
                    'member_hashcode': contact.hashcode ?? '',
                    'member_name': controller.getContactName(contact),
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
