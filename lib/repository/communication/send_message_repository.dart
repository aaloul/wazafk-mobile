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
}
