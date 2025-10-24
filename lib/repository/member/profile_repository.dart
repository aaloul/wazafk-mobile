import '../../model/LoginResponse.dart';
import '../../model/MemberProfileResponse.dart';
import '../../model/ProfileResponse.dart';
import '../../networking/services/member/profile_service.dart';

class ProfileRepository {
  final _provider = ProfileService();

  Future<ProfileResponse> getProfile() async {
    return _provider.getProfile();
  }

  Future<MemberProfileResponse> getMemberProfile(
      {Map<String, String>? filters}) async {
    return _provider.getMemberProfile(filters: filters);
  }

  Future<LoginResponse> editProfile(Map<String, dynamic> data) async {
    return _provider.editProfile(data);
  }

  Future<LoginResponse> editProfileImage(String imageBase64) async {
    return _provider.editProfileImage(imageBase64);
  }
}
