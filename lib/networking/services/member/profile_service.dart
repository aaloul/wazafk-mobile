import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ProfileService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getProfile(String hashcode) async {
    final response = await _helper.get("${Endpoints.profile}/$hashcode");
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> editProfile(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.editProfile, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> editProfileImage(String imageBase64) async {
    final Map<String, dynamic> body = {'image': imageBase64};
    final response = await _helper.post(Endpoints.editProfileImage, body);
    return ApiResponse.fromJson(response);
  }
}
