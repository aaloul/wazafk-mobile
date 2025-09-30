import '../../networking/services/support/send_message_service.dart';
import '../../model/ApiResponse.dart';

class SendMessageRepository {
  final _provider = SendMessageService();

  Future<ApiResponse> sendMessage(
    String chatHashcode,
    String message, {
    String? attachment,
  }) async {
    return _provider.sendMessage(chatHashcode, message, attachment: attachment);
  }
}
