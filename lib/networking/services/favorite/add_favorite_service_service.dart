import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AddFavoriteServiceService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addFavoriteService(String hashcode) async {
    final Map<String, dynamic> body = {'favorite_service': hashcode};
    final response = await _helper.post(Endpoints.addFavoriteService, body);
    return ApiResponse.fromJson(response);
  }
}
