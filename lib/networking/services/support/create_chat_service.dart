import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class CreateChatService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> createChat(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.createChat, data);
    return response;
  }
}
