import 'dart:io';

import 'package:http/http.dart';
import 'package:wazafak_app/model/ApiResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SendMessageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> sendMessage({
    required String member,
    required String message,
  }) async {
    final Map<String, dynamic> body = {'member': member, 'message': message};
    final response = await _helper.post(Endpoints.sendMessage, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> sendMessageWithAttachment({
    required String member,
    String? message,
    required File attachment,
    required String attachmentType,
  }) async {
    // Prepare fields
    Map<String, String> fields = {
      'member': member,
      'attachment_type': attachmentType,
    };

    if (message != null && message.isNotEmpty) {
      fields['message'] = message;
    }

    // Prepare files
    List<MultipartFile> files = [];
    files.add(await MultipartFile.fromPath('attachment', attachment.path));

    final response = await _helper.postMultipart(
      Endpoints.sendMessage,
      fields,
      files,
    );

    return ApiResponse.fromJson(response);
  }
}
