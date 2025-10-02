import '../../model/ApiResponse.dart';
import '../../model/MemberSkillsResponse.dart';
import '../../networking/services/member/skills_service.dart';

class MemberSkillsRepository {
  final _provider = MemberSkillsService();

  Future<ApiResponse> addSkill(String skillHashcode) async {
    return _provider.addSkill(skillHashcode);
  }

  Future<ApiResponse> removeSkill(String skillHashcode) async {
    return _provider.removeSkill(skillHashcode);
  }

  Future<MemberSkillsResponse> getSkills() async {
    return _provider.getSkills();
  }
}
