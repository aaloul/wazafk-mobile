import 'package:wazafak_app/model/CategoriesResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class CategoriesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoriesResponse> getCategories({
    String? type,
    String? parent,
    String? name,
  }) async {
    String url = Endpoints.categories;
    List<String> params = [];

    if (type != null) params.add('type=$type');
    if (parent != null) params.add('parent=$parent');
    if (name != null) params.add('name=$name');

    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }

    final response = await _helper.get(url);
    return response;
  }
}
