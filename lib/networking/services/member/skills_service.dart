import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class MemberSkillsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addSkill(String skillHashcode) async {
    final Map<String, dynamic> body = {'skill_hashcode': skillHashcode};
    final response = await _helper.post(Endpoints.addSkill, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> removeSkill(String skillHashcode) async {
    final Map<String, dynamic> body = {'skill_hashcode': skillHashcode};
    final response = await _helper.post(Endpoints.removeSkill, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getSkills() async {
    final response = await _helper.get(Endpoints.memberSkills);
    return ApiResponse.fromJson(response);
  }
}
