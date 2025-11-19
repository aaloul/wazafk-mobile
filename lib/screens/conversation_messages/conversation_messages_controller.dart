import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../model/ConversationMessagesResponse.dart';
import '../../repository/communication/conversation_messages_repository.dart';
import '../../repository/communication/send_message_repository.dart';
import '../../utils/Prefs.dart';
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

  // late MyListingItem secondary;
  bool isSender = false;

  Future<void> getMessages() async {
    try {
      final response = await _conversationMessagesRepository
          .getConversationMessages(customerId: customerHashcode, page: '1');
      if (response.success ?? false) {
        messages.value = response.data?.list ?? [];

        grouped.value = groupBy<ConversationMessage, String>(messages.value, (
          message,
        ) {
          DateTime time = message.createdAt!;
          if (time.day == DateTime.now().day) {
            return "Today";
          } else if (time.day == DateTime.now().day - 1) {
            return "Yesterday";
          }
          return "${time.day}-${time.month}-${time.year}";
        });

        scrollToBottom();
        initPusher(
          response.data!.conversationEventDetails!.channelName.toString(),
          response.data!.conversationEventDetails!.eventListenerName.toString(),
        );
      } else {
        constants.showSnackBar(
          response.message.toString(),
          SnackBarStatus.ERROR,
        );
      }
      isMessagesLoading(false);
    } catch (e) {
      isMessagesLoading(false);
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
      constants.showSnackBar("No Internet Connection!", SnackBarStatus.ERROR);
    }
  }

  late StreamSubscription<bool> keyboardSubscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    isMessagesLoading(true);

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

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    keyboardSubscription.cancel();
  }

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  Future<void> initPusher(String channel, String eventName) async {
    channelName = channel;
    this.eventName = eventName;
    try {
      await pusher.subscribe(
        channelName: channel,
        onEvent: (dynamic event) {
          if (event.eventName.toString() == eventName.toString()) {
            ConversationMessage m = ConversationMessage.fromJson(
              json.decode(event.data),
            );
            if (m.senderHashcode != Prefs.getId) {
              addMessage(m);
              getMessages();
            }
            scrollToBottom();
            scrollToBottom();
          }
        },
      );
      await pusher.connect();
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
        return 'Today';
      } else if (time.day == DateTime.now().day - 1) {
        return 'Yesterday';
      }
      return "${time.day}-${time.month}-${time.year}";
    });

    grouped.refresh();
  }
}
