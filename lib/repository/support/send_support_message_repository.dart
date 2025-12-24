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
}
