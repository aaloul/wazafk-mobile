import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SendSupportMessageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> sendMessage(
    String chatHashcode,
    String message, {
    String? attachment,
  }) async {
    final Map<String, dynamic> body = {
      'conversation': chatHashcode,
      'message': message,
    };
    final response = await _helper.post(Endpoints.sendSupportMessage, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> sendMessageWithAttachment({
    required String chatHashcode,
    String? message,
    required File attachment,
    required String attachmentType,
  }) async {
    Map<String, String> fields = {
      'conversation': chatHashcode,
      'attachment_type': attachmentType,
    };

    if (message != null && message.isNotEmpty) {
      fields['message'] = message;
    }

    List<http.MultipartFile> files = [];
    files.add(await http.MultipartFile.fromPath('attachment', attachment.path));

    final response = await _helper.postMultipart(
      Endpoints.sendSupportMessage,
      fields,
      files,
    );

    return ApiResponse.fromJson(response);
  }
}
