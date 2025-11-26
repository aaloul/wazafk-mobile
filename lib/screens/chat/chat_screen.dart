import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/skeletons/conversation_item_skeleton.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/chat/chat_controller.dart';
import 'package:wazafak_app/screens/chat/components/chat_tab_bar.dart';
import 'package:wazafak_app/screens/chat/components/contact_list_item.dart';
import 'package:wazafak_app/screens/chat/components/conversation_list_item.dart';
import 'package:wazafak_app/screens/chat/components/empty_state_view.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        controller.loadConversations(false);
      },
      child: Scaffold(
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
    return Obx(() {
      // Loading state
      if (controller.conversations.isEmpty &&
          controller.isLoadingConversations.value) {
        return ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ConversationItemSkeleton(),
        );
      }

      // Error state with retry
      if (controller.conversations.isEmpty &&
          !controller.isLoadingConversations.value &&
          controller.hasConversationsError.value) {
        return EmptyStateView(
          message: controller.conversationsErrorMessage.value,
          icon: Icons.error_outline,
          showRetry: true,
          onRetry: controller.retryLoadConversations,
        );
      }

      // Empty state
      if (controller.conversations.isEmpty &&
          !controller.isLoadingConversations.value) {
        return EmptyStateView(
          message: "No ongoing chats",
          icon: Icons.chat_bubble_outline,
        );
      }

      // Conversations list
      return RefreshIndicator(
        onRefresh: controller.refreshConversations,
        color: context.resources.color.colorPrimary,
        child: ListView.builder(
          controller: controller.conversationsScrollController,
          // padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.conversations.length +
              (controller.hasMoreConversations.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.conversations.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ProgressBar(
                    color: context.resources.color.colorPrimary,
                  ),
                ),
              );
            }

            final conversation = controller.conversations[index];
            return ConversationListItem(
              conversation: conversation,
              conversationName: controller.getConversationName(conversation),
              lastMessageTime: controller.formatLastMessageTime(
                conversation.lastMessage?.createdAt,
              ),
              onTap: () {
                Get.toNamed(
                  RouteConstant.conversationMessagesScreen,
                  arguments: {
                    'member_hashcode': conversation.hashcode ?? '',
                    'member_name': controller.getConversationName(conversation),
                  },
                );
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildActiveEmployersTab(BuildContext context) {
    return Obx(() {
      // Loading state
      if (controller.contacts.isEmpty && controller.isLoading.value) {
        return ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ConversationItemSkeleton(),
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
          // padding: EdgeInsets.symmetric(horizontal: 16),
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
