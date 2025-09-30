import '../../model/ApiResponse.dart';
import '../../networking/services/member/member_service.dart';

class MemberRepository {
  final _provider = MemberService();

  Future<ApiResponse> checkMemberExists(String mobile) async {
    return _provider.checkMemberExists(mobile);
  }

  Future<ApiResponse> getMembers({Map<String, String>? filters}) async {
    return _provider.getMembers(filters: filters);
  }

  Future<ApiResponse> getProfile(String hashcode) async {
    return _provider.getProfile(hashcode);
  }

  Future<ApiResponse> editProfile(Map<String, dynamic> data) async {
    return _provider.editProfile(data);
  }

  Future<ApiResponse> editProfileImage(String imageBase64) async {
    return _provider.editProfileImage(imageBase64);
  }

  Future<ApiResponse> saveInterests(List<String> interests) async {
    return _provider.saveInterests(interests);
  }

  Future<ApiResponse> getInterests() async {
    return _provider.getInterests();
  }

  Future<ApiResponse> addSkill(String skillHashcode) async {
    return _provider.addSkill(skillHashcode);
  }

  Future<ApiResponse> removeSkill(String skillHashcode) async {
    return _provider.removeSkill(skillHashcode);
  }

  Future<ApiResponse> getSkills() async {
    return _provider.getSkills();
  }

  Future<ApiResponse> saveDocument(Map<String, dynamic> data) async {
    return _provider.saveDocument(data);
  }

  Future<ApiResponse> getDocuments() async {
    return _provider.getDocuments();
  }

  Future<ApiResponse> addAddress(Map<String, dynamic> data) async {
    return _provider.addAddress(data);
  }

  Future<ApiResponse> saveAddress(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.saveAddress(hashcode, data);
  }

  Future<ApiResponse> getAddresses() async {
    return _provider.getAddresses();
  }

  Future<ApiResponse> addScheduleTask(Map<String, dynamic> data) async {
    return _provider.addScheduleTask(data);
  }

  Future<ApiResponse> saveScheduleTask(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.saveScheduleTask(hashcode, data);
  }

  Future<ApiResponse> deleteScheduleTask(String hashcode) async {
    return _provider.deleteScheduleTask(hashcode);
  }

  Future<ApiResponse> getScheduleTasks() async {
    return _provider.getScheduleTasks();
  }
}
