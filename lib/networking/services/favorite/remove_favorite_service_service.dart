import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RemoveFavoriteServiceService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> removeFavoriteService(String hashcode) async {
    final Map<String, dynamic> body = {'favorite_service': hashcode};
    final response = await _helper.post(Endpoints.removeFavoriteService, body);
    return ApiResponse.fromJson(response);
  }
}
