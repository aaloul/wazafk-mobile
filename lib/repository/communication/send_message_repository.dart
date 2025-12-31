import 'dart:io';

import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/communication/send_message_service.dart';

class SendMessageRepository {
  final _provider = SendMessageService();

  Future<ApiResponse> sendMessage({
    required String memberHashcode,
    required String message,
  }) async {
    return _provider.sendMessage(member: memberHashcode, message: message);
  }

  Future<ApiResponse> sendMessageWithAttachment({
    required String memberHashcode,
    String? message,
    required File attachment,
    required String attachmentType,
  }) async {
    return _provider.sendMessageWithAttachment(
      member: memberHashcode,
      message: message,
      attachment: attachment,
      attachmentType: attachmentType,
    );
  }
}
