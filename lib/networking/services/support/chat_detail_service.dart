import '../../../model/ApiResponse.dart';
import '../../api_base_helper.dart';

class ChatDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getChat(String hashcode) async {
    final response = await _helper.get('support/chat/$hashcode');
    return response;
  }
}
