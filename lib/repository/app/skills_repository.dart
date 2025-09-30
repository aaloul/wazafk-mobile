import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/app/skills_service.dart';

class SkillsRepository {
  final _provider = SkillsService();

  Future<ApiResponse> getSkills({String? name}) async {
    return _provider.getSkills(name: name);
  }
}
