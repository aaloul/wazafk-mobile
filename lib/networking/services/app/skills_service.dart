import '../../../model/SkilsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SkillsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SkillsResponse> getSkills({String? name}) async {
    String url = Endpoints.skills;
    if (name != null && name.isNotEmpty) {
      url += '?name=$name';
    }
    final response = await _helper.get(url);
    return SkillsResponse.fromJson(response);
  }
}
