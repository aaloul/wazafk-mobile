import '../../model/SkillsResponse.dart';
import '../../networking/services/app/skills_service.dart';

class SkillsRepository {
  final _provider = SkillsService();

  Future<SkillsResponse> getSkills({String? name, String? category}) async {
    return _provider.getSkills(name: name, category: category);
  }
}
