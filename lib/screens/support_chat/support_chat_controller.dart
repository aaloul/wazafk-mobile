import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:wazafak_app/model/SupportConversationMessagesResponse.dart';
import 'package:wazafak_app/model/SupportStartConversationResponse.dart';
import 'package:wazafak_app/repository/support/close_support_chat_repository.dart';
import 'package:wazafak_app/repository/support/send_support_message_repository.dart';
import 'package:wazafak_app/repository/support/support_messages_repository.dart';

import '../../utils/Prefs.dart';
import '../../utils/pusher_manager.dart';
import '../../utils/res/Resources.dart';
import '../../utils/utils.dart';

class SupportChatController extends GetxController {
  final SupportMessagesRepository _supportMessagesRepository =
      SupportMessagesRepository();

  final SendSupportMessageRepository _sendSupportMessageRepository =
      SendSupportMessageRepository();

  final CloseSupportChatRepository _closeSupportChatRepository =
      CloseSupportChatRepository();

  var isMessagesLoading = false.obs;
  var isSendLoading = false.obs;
  var isEndingConversation = false.obs;
  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RxList<SupportConversationMessage> messages =
      <SupportConversationMessage>[].obs;

  SupportConversation? conversation;
  String conversationHashcode = '';
  String channelName = '';
  String eventName = '';

  RxMap grouped = {}.obs;

  // Pagination
  int currentPage = 1;
  int lastPage = 1;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

  Future<void> getMessages({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore.value || !hasMoreData.value) return;
      isLoadingMore(true);
    }

    try {
      final response = await _supportMessagesRepository
          .getSupportConversationMessages(conversation: conversationHashcode);

      if (response.success ?? false) {
        final newMessages = response.data?.list ?? [];

        // Update pagination info
        currentPage = response.data?.meta?.page ?? 1;
        lastPage = response.data?.meta?.last ?? 1;
        hasMoreData.value = currentPage < lastPage;

        if (loadMore) {
          // Append older messages at the end (since messages are in reverse order)
          messages.addAll(newMessages);
        } else {
          messages.value = newMessages;
        }

        grouped.value =
            groupBy<SupportConversationMessage, String>(messages.value, (
          message,
        ) {
          DateTime time = message.createdAt!;
          if (time.day == DateTime.now().day) {
            return Resources.of(Get.context!).strings.today;
          } else if (time.day == DateTime.now().day - 1) {
            return Resources.of(Get.context!).strings.yesterday;
          }
          return "${time.day}-${time.month}-${time.year}";
        });

        if (!loadMore) {
          scrollToBottom();
          // Initialize pusher with channel from conversation
          if (conversation?.channelName != null) {
            initPusher(
              conversation!.channelName!,
              'message.created',
            );
          }
        }
      } else {
        constants.showSnackBar(
          response.message.toString(),
          SnackBarStatus.ERROR,
        );
      }
      isMessagesLoading(false);
      isLoadingMore(false);
    } catch (e) {
      isMessagesLoading(false);
      isLoadingMore(false);
      print('Error loading support messages: $e');
    }
  }

  Future<void> sendMessages() async {
    if (messageController.text.isEmpty) {
      return;
    }

    SupportConversationMessage m = SupportConversationMessage(
      senderType: 'M',
      memberFirstName: Prefs.getFName,
      memberLastName: Prefs.getLName,
      message: messageController.text.toString(),
      createdAt: DateTime.now(),
    );
    addMessage(m);

    messageController.text = '';
    scrollToBottom();
    isSendLoading(true);

    try {
      final response = await _sendSupportMessageRepository.sendMessage(
        chatHashcode: conversationHashcode,
        message: m.message.toString(),
      );
      if (response.success ?? false) {
        // Message sent successfully
      } else {
        constants.showSnackBar(
          response.message.toString(),
          SnackBarStatus.ERROR,
        );
      }
      isSendLoading(false);
    } catch (e) {
      isSendLoading(false);
      constants.showSnackBar(
          Resources.of(Get.context!).strings.noInternetConnection,
          SnackBarStatus.ERROR);
    }
  }

  Future<void> endConversation() async {
    try {
      isEndingConversation(true);

      final response = await _closeSupportChatRepository.createChat(
        hashcode: conversationHashcode,
      );

      if (response.success ?? false) {
        constants.showSnackBar(
          Resources.of(Get.context!).strings.conversationEndedSuccessfully,
          SnackBarStatus.SUCCESS,
        );
        // Navigate back to previous screen
        Get.back();
        Get.back();
      } else {
        constants.showSnackBar(
          response.message ??
              Resources.of(Get.context!).strings.failedToSubmit,
          SnackBarStatus.ERROR,
        );
      }
      isEndingConversation(false);
    } catch (e) {
      isEndingConversation(false);
      constants.showSnackBar(
        Resources.of(Get.context!).strings.failedToSubmit,
        SnackBarStatus.ERROR,
      );
    }
  }

  late StreamSubscription<bool> keyboardSubscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    isMessagesLoading(true);

    // Add scroll listener for pagination
    scrollController.addListener(_onScroll);

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((
      bool visible,
    ) {
      print('Keyboard visibility update. Is visible: $visible');
      Future.delayed(const Duration(milliseconds: 400), () {
        scrollToBottom();
      });
    });
  }

  void _onScroll() {
    // Load more when scrolled to top (for older messages)
    if (scrollController.position.pixels <= 100) {
      getMessages(loadMore: true);
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    keyboardSubscription.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    // Clear the callback when controller is disposed
    PusherManager.onEventCallback = null;
    super.onClose();
  }

  // Expose pusher for unsubscribe operations
  PusherChannelsFlutter get pusher => PusherManager.pusher;

  Future<void> initPusher(String channel, String eventName) async {
    print("initPusher: $channel");
    print("initPusher: $eventName");

    channelName = channel;
    this.eventName = eventName;
    try {
      // Set the global event callback
      PusherManager.onEventCallback = (PusherEvent event) {
        print("event_support: $event");

        if (event.eventName.toString() == eventName.toString()) {
          try {
            SupportConversationMessage m =
                SupportConversationMessage.fromJson(
              json.decode(event.data),
            );
            // Only add if not sent by current user
            if (m.senderType != 'MEMBER') {
              addMessage(m);
            }
            scrollToBottom();
            scrollToBottom();
          } catch (e) {
            print('Error parsing support message from pusher: $e');
          }
        }
      };

      // Use the pusher instance from PusherManager
      await PusherManager.pusher.subscribe(channelName: channel);
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController
            .animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(microseconds: 100),
              curve: Curves.ease,
            )
            .then((value) async {});
      }
    });
  }

  void addMessage(SupportConversationMessage m) {
    messages.insert(0, m);
    grouped.value =
        groupBy<SupportConversationMessage, String>(messages.value, (
      message,
    ) {
      DateTime time = message.createdAt!;
      if (time.day == DateTime.now().day) {
        return Resources.of(Get.context!).strings.today;
      } else if (time.day == DateTime.now().day - 1) {
        return Resources.of(Get.context!).strings.yesterday;
      }
      return "${time.day}-${time.month}-${time.year}";
    });

    grouped.refresh();
  }
}
