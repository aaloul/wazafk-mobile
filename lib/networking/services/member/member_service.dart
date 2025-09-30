import 'package:wazafak_app/model/ApiResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class MemberService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> checkMemberExists(String mobile) async {
    final response = await _helper.get(
      "${Endpoints.checkMemberExists}?mobile=$mobile",
    );
    return response;
  }

  Future<ApiResponse> getMembers({Map<String, String>? filters}) async {
    String url = Endpoints.members;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return response;
  }

  Future<ApiResponse> getProfile(String hashcode) async {
    final response = await _helper.get("${Endpoints.profile}/$hashcode");
    return response;
  }

  Future<ApiResponse> editProfile(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.editProfile, data);
    return response;
  }

  Future<ApiResponse> editProfileImage(String imageBase64) async {
    final Map<String, dynamic> body = {'image': imageBase64};
    final response = await _helper.post(Endpoints.editProfileImage, body);
    return response;
  }

  Future<ApiResponse> saveInterests(List<String> interests) async {
    final Map<String, dynamic> body = {'interests': interests};
    final response = await _helper.post(Endpoints.saveInterests, body);
    return response;
  }

  Future<ApiResponse> getInterests() async {
    final response = await _helper.get(Endpoints.interests);
    return response;
  }

  Future<ApiResponse> addSkill(String skillHashcode) async {
    final Map<String, dynamic> body = {'skill_hashcode': skillHashcode};
    final response = await _helper.post(Endpoints.addSkill, body);
    return response;
  }

  Future<ApiResponse> removeSkill(String skillHashcode) async {
    final Map<String, dynamic> body = {'skill_hashcode': skillHashcode};
    final response = await _helper.post(Endpoints.removeSkill, body);
    return response;
  }

  Future<ApiResponse> getSkills() async {
    final response = await _helper.get(Endpoints.memberSkills);
    return response;
  }

  Future<ApiResponse> saveDocument(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.saveDocument, data);
    return response;
  }

  Future<ApiResponse> getDocuments() async {
    final response = await _helper.get(Endpoints.documents);
    return response;
  }

  Future<ApiResponse> addAddress(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addAddress, data);
    return response;
  }

  Future<ApiResponse> saveAddress(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveAddress, data);
    return response;
  }

  Future<ApiResponse> getAddresses() async {
    final response = await _helper.get(Endpoints.addresses);
    return response;
  }

  Future<ApiResponse> addScheduleTask(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addScheduleTask, data);
    return response;
  }

  Future<ApiResponse> saveScheduleTask(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveScheduleTask, data);
    return response;
  }

  Future<ApiResponse> deleteScheduleTask(String hashcode) async {
    final response = await _helper.delete(
      "${Endpoints.deleteScheduleTask}/$hashcode",
    );
    return response;
  }

  Future<ApiResponse> getScheduleTasks() async {
    final response = await _helper.get(Endpoints.scheduleTasks);
    return response;
  }
}
