import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../components/sheets/attachment_options_bottom_sheet.dart';
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

  // Voice recording
  var isRecording = false.obs;
  RecorderController? recorderController;
  String? currentRecordingPath;

  // Attachment
  var selectedAttachment = Rxn<File>();
  var attachmentType = Rxn<String>();
  var attachmentName = Rxn<String>();
  var isUploadingAttachment = false.obs;
  var uploadProgress = 0.0.obs;

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

    // Initialize recorder controller
    recorderController = RecorderController();

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
    recorderController?.dispose();
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

  // Voice recording methods
  Future<void> startVoiceRecording() async {
    try {
      // Check permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        constants.showSnackBar(
          Resources.of(Get.context!).strings.microphonePermissionDenied,
          SnackBarStatus.ERROR,
        );
        return;
      }

      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      currentRecordingPath =
          '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Start recording
      await recorderController?.record(path: currentRecordingPath!);
      isRecording.value = true;
    } catch (e) {
      print('Error starting recording: $e');
      constants.showSnackBar(
        'Error starting recording: $e',
        SnackBarStatus.ERROR,
      );
    }
  }

  Future<void> cancelVoiceRecording() async {
    try {
      await recorderController?.stop();
      isRecording.value = false;

      // Delete the recording file
      if (currentRecordingPath != null) {
        final file = File(currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      currentRecordingPath = null;
    } catch (e) {
      print('Error cancelling recording: $e');
    }
  }

  Future<void> sendVoiceRecording() async {
    try {
      final path = await recorderController?.stop();
      isRecording.value = false;

      if (path == null || currentRecordingPath == null) {
        constants.showSnackBar(
          'Error: Recording path not found',
          SnackBarStatus.ERROR,
        );
        return;
      }

      final file = File(currentRecordingPath!);
      if (!await file.exists()) {
        constants.showSnackBar(
          'Error: Recording file not found',
          SnackBarStatus.ERROR,
        );
        return;
      }

      // Send voice message
      await _sendAttachment(
        file: file,
        attachmentType: 'voice',
      );

      currentRecordingPath = null;
    } catch (e) {
      print('Error sending voice recording: $e');
      constants.showSnackBar(
        'Error sending voice: $e',
        SnackBarStatus.ERROR,
      );
    }
  }

  // Attachment selection methods
  Future<void> handleAttachmentSelection(AttachmentType type) async {
    try {
      File? file;
      String? fileName;
      String? attachType;

      switch (type) {
        case AttachmentType.camera:
          final xFile = await ImagePicker().pickImage(
            source: ImageSource.camera,
            imageQuality: 80,
          );
          if (xFile != null) {
            file = await _compressImage(File(xFile.path));
            fileName = xFile.name;
            attachType = 'image';
          }
          break;

        case AttachmentType.gallery:
          final xFile = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );
          if (xFile != null) {
            file = await _compressImage(File(xFile.path));
            fileName = xFile.name;
            attachType = 'image';
          }
          break;

        case AttachmentType.video:
          final xFile = await ImagePicker().pickVideo(
            source: ImageSource.gallery,
          );
          if (xFile != null) {
            file = File(xFile.path);
            fileName = xFile.name;
            attachType = 'video';

            // Check file size (max 50MB)
            final fileSize = await file.length();
            if (fileSize > 50 * 1024 * 1024) {
              constants.showSnackBar(
                Resources.of(Get.context!).strings.fileTooLarge,
                SnackBarStatus.ERROR,
              );
              return;
            }
          }
          break;

        case AttachmentType.document:
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: [
              'pdf',
              'doc',
              'docx',
              'xls',
              'xlsx',
              'ppt',
              'pptx'
            ],
          );
          if (result != null && result.files.single.path != null) {
            file = File(result.files.single.path!);
            fileName = result.files.single.name;
            attachType = 'document';
          }
          break;

        case AttachmentType.file:
          final result = await FilePicker.platform.pickFiles();
          if (result != null && result.files.single.path != null) {
            file = File(result.files.single.path!);
            fileName = result.files.single.name;
            attachType = 'file';
          }
          break;
      }

      if (file != null && attachType != null) {
        selectedAttachment.value = file;
        attachmentName.value = fileName;
        attachmentType.value = attachType;
      }
    } catch (e) {
      print('Error selecting attachment: $e');
      constants.showSnackBar(
        'Error selecting file: $e',
        SnackBarStatus.ERROR,
      );
    }
  }

  void removeAttachment() {
    selectedAttachment.value = null;
    attachmentName.value = null;
    attachmentType.value = null;
  }

  Future<File> _compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      return result != null ? File(result.path) : file;
    } catch (e) {
      print('Error compressing image: $e');
      return file;
    }
  }

  Future<void> sendMessageWithAttachment() async {
    if (selectedAttachment.value == null) {
      sendMessages(); // Send text-only message
      return;
    }

    await _sendAttachment(
      file: selectedAttachment.value!,
      attachmentType: attachmentType.value!,
      message: messageController.text.trim().isEmpty
          ? null
          : messageController.text.trim(),
    );
  }

  Future<void> _sendAttachment({
    required File file,
    required String attachmentType,
    String? message,
  }) async {
    try {
      isUploadingAttachment.value = true;
      uploadProgress.value = 0.0;

      // Create optimistic message
      ConversationMessage optimisticMessage = ConversationMessage(
        senderHashcode: Prefs.getId,
        message: message,
        createdAt: DateTime.now(),
        attachmentType: attachmentType,
        // Local file path for preview (will be replaced with server URL)
        attachmentUrl: file.path,
      );
      addMessage(optimisticMessage);

      // Clear input
      messageController.clear();
      removeAttachment();
      scrollToBottom();

      // Send to server
      final response = await _sendMessageRepository.sendMessageWithAttachment(
        memberHashcode: customerHashcode,
        message: message,
        attachment: file,
        attachmentType: attachmentType,
      );

      if (response.success ?? false) {
        // Message sent successfully
        // Remove optimistic message and refresh from API
        messages.removeWhere((m) =>
            m.messageHashcode == null &&
            m.createdAt == optimisticMessage.createdAt);

        // Refresh messages from API
        await getMessages();
      } else {
        constants.showSnackBar(
          response.message.toString(),
          SnackBarStatus.ERROR,
        );
        // Remove optimistic message on error
        messages.remove(optimisticMessage);
      }

      isUploadingAttachment.value = false;
      uploadProgress.value = 0.0;
    } catch (e) {
      isUploadingAttachment.value = false;
      uploadProgress.value = 0.0;
      constants.showSnackBar(
        'Error sending attachment: $e',
        SnackBarStatus.ERROR,
      );
    }
  }
}
