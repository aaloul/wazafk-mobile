import 'package:wazafak_app/model/CategoriesResponse.dart';

import '../../networking/services/app/categories_service.dart';

class CategoriesRepository {
  final _provider = CategoriesService();

  Future<CategoriesResponse> getCategories({
    String? type,
    String? parent,
    String? name,
  }) async {
    return _provider.getCategories(type: type, parent: parent, name: name);
  }
}
