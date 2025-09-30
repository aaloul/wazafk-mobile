import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ChatsListService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getChats() async {
    final response = await _helper.get(Endpoints.chats);
    return response;
  }
}
