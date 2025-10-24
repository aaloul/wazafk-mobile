import 'package:http/http.dart' as http;
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';

import '../../../model/ProfileResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ProfileService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ProfileResponse> getProfile() async {
    final response = await _helper.get(Endpoints.profile);
    return ProfileResponse.fromJson(response);
  }

  Future<MemberProfileResponse> getMemberProfile(
      {Map<String, String>? filters}) async {
    String url = Endpoints.memberProfile;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }


    final response = await _helper.get(url);
    return MemberProfileResponse.fromJson(response);
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
