import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RemoveFavoritePackageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> removeFavoritePackage(String hashcode) async {
    final Map<String, dynamic> body = {'favorite_package': hashcode};
    final response = await _helper.post(Endpoints.removeFavoritePackage, body);
    return ApiResponse.fromJson(response);
  }
}
