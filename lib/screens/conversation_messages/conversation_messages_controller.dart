import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../model/ConversationMessagesResponse.dart';
import '../../repository/communication/conversation_messages_repository.dart';
import '../../repository/communication/send_message_repository.dart';
import '../../utils/Prefs.dart';
import '../../utils/pusher_manager.dart';
import '../../utils/res/Resources.dart';
import '../../utils/utils.dart';

class ConversationMessagesController extends GetxController {
  final ConversationMessagesRepository _conversationMessagesRepository =
      ConversationMessagesRepository();

  final SendMessageRepository _sendMessageRepository = SendMessageRepository();

  var isMessagesLoading = false.obs;
  var isSendLoading = false.obs;
  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RxList<ConversationMessage> messages = <ConversationMessage>[].obs;

  String customerHashcode = '';
  String channelName = '';
  String eventName = '';

  RxMap grouped = {}.obs;

  var isDataLoading = false.obs;
  var isOfferDataLoading = false.obs;
  var isAcceptLoading = false.obs;
  var isCancelLoading = false.obs;
  var isAddToCalendarLoading = false.obs;
  var addToCalendarListVisible = false.obs;

  var dateTimePage = 'date'.obs;

  // Pagination
  int currentPage = 1;
  int lastPage = 1;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

  // late MyListingItem secondary;
  bool isSender = false;

  Future<void> getMessages({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore.value || !hasMoreData.value) return;
      isLoadingMore(true);
    }

    try {
      final page = loadMore ? currentPage + 1 : 1;
      final response = await _conversationMessagesRepository
          .getConversationMessages(
          customerId: customerHashcode, page: page.toString());
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

        grouped.value = groupBy<ConversationMessage, String>(messages.value, (
          message,
        ) {
          DateTime time = message.createdAt!;
          if (time.day == DateTime.now().day) {
            return Resources
                .of(Get.context!)
                .strings
                .today;
          } else if (time.day == DateTime.now().day - 1) {
            return Resources
                .of(Get.context!)
                .strings
                .yesterday;
          }
          return "${time.day}-${time.month}-${time.year}";
        });

        if (!loadMore) {
          scrollToBottom();
          initPusher(
            response.data!.conversationEventDetails!.channelName.toString(),
            response.data!.conversationEventDetails!.eventListenerName
                .toString(),
          );
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
      // DialogHelper.showNoInternetPopup(Get.context!, () {
      //   getMessages();
      // });

      // constants.showSnackBar(e.toString(), SnackBarStatus.ERROR);
    }
  }

  Future<void> sendMessages() async {
    if (messageController.text.isEmpty) {
      return;
    }

    ConversationMessage m = ConversationMessage(
      senderHashcode: Prefs.getId,
      message: messageController.text.toString(),
      createdAt: DateTime.now(),
    );
    addMessage(m);

    messageController.text = '';
    scrollToBottom();
    isSendLoading(true);

    try {
      final response = await _sendMessageRepository.sendMessage(
        memberHashcode: customerHashcode,
        message: m.message.toString(),
      );
      if (response.success ?? false) {
      } else {
        constants.showSnackBar(
          response.message.toString(),
          SnackBarStatus.ERROR,
        );
      }
      isSendLoading(false);
    } catch (e) {
      isSendLoading(false);
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .noInternetConnection, SnackBarStatus.ERROR);
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
        print("event_aaa: $event");

        if (event.eventName.toString() == eventName.toString()) {
          ConversationMessage m = ConversationMessage.fromJson(
            json.decode(event.data),
          );
          if (m.senderHashcode != Prefs.getId) {
            addMessage(m);
            // getMessages();
          }
          scrollToBottom();
          scrollToBottom();
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
      scrollController
          .animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(microseconds: 100),
            curve: Curves.ease,
          )
          .then((value) async {});
    });
  }

  void addMessage(ConversationMessage m) {
    messages.insert(0, m);
    grouped.value = groupBy<ConversationMessage, String>(messages.value, (
      message,
    ) {
      DateTime time = message.createdAt!;
      if (time.day == DateTime.now().day) {
        return Resources
            .of(Get.context!)
            .strings
            .today;
      } else if (time.day == DateTime.now().day - 1) {
        return Resources
            .of(Get.context!)
            .strings
            .yesterday;
      }
      return "${time.day}-${time.month}-${time.year}";
    });

    grouped.refresh();
  }
}
