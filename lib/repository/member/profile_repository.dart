import '../../model/LoginResponse.dart';
import '../../networking/services/member/profile_service.dart';

class ProfileRepository {
  final _provider = ProfileService();

  Future<LoginResponse> getProfile(String hashcode) async {
    return _provider.getProfile(hashcode);
  }

  Future<LoginResponse> editProfile(Map<String, dynamic> data) async {
    return _provider.editProfile(data);
  }

  Future<LoginResponse> editProfileImage(String imageBase64) async {
    return _provider.editProfileImage(imageBase64);
  }
}
