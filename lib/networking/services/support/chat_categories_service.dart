import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ChatCategoriesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getChatCategories() async {
    final response = await _helper.get(Endpoints.chatCategories);
    return ApiResponse.fromJson(response);
  }
}
