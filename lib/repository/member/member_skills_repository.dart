import '../../model/ApiResponse.dart';
import '../../networking/services/member/skills_service.dart';

class MemberSkillsRepository {
  final _provider = MemberSkillsService();

  Future<ApiResponse> addSkill(String skillHashcode) async {
    return _provider.addSkill(skillHashcode);
  }

  Future<ApiResponse> removeSkill(String skillHashcode) async {
    return _provider.removeSkill(skillHashcode);
  }

  Future<ApiResponse> getSkills() async {
    return _provider.getSkills();
  }
}
