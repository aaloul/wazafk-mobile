import '../../../model/SkillsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SkillsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SkillsResponse> getSkills({String? name, String? category}) async {
    String url = Endpoints.skills;
    List<String> params = [];

    if (name != null && name.isNotEmpty) {
      params.add('name=$name');
    }

    if (category != null && category.isNotEmpty) {
      params.add('category=$category');
    }

    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }

    final response = await _helper.get(url);
    return SkillsResponse.fromJson(response);
  }
}
