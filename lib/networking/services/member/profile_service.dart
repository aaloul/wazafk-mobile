import 'package:http/http.dart' as http;
import 'package:wazafak_app/model/LoginResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ProfileService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginResponse> getProfile(String hashcode) async {
    final response = await _helper.get("${Endpoints.profile}/$hashcode");
    return LoginResponse.fromJson(response);
  }

  Future<LoginResponse> editProfile(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.editProfile, data);
    return LoginResponse.fromJson(response);
  }

  Future<LoginResponse> editProfileImage(String imagePath) async {
    final file = await http.MultipartFile.fromPath('image', imagePath);
    final response = await _helper.postMultipart(
      Endpoints.editProfileImage,
      {},
      [file],
    );
    return LoginResponse.fromJson(response);
  }
}
