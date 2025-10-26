import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AddFavoritePackageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addFavoritePackage(String hashcode) async {
    final Map<String, dynamic> body = {'favorite_package': hashcode};
    final response = await _helper.post(Endpoints.addFavoritePackage, body);
    return ApiResponse.fromJson(response);
  }
}
