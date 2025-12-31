import 'dart:io';

import '../../model/ApiResponse.dart';
import '../../networking/services/support/send_support_message_service.dart';

class SendSupportMessageRepository {
  final _provider = SendSupportMessageService();

  Future<ApiResponse> sendMessage({
    required String chatHashcode,
    required String message,
  }) async {
    return _provider.sendMessage(chatHashcode, message);
  }

  Future<ApiResponse> sendMessageWithAttachment({
    required String chatHashcode,
    String? message,
    required File attachment,
    required String attachmentType,
  }) async {
    return _provider.sendMessageWithAttachment(
      chatHashcode: chatHashcode,
      message: message,
      attachment: attachment,
      attachmentType: attachmentType,
    );
  }
}
