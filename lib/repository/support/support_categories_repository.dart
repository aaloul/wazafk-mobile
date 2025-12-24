import '../../model/SupportCategoriesResponse.dart';
import '../../networking/services/support/support_categories_service.dart';

class SupportCategoriesRepository {
  final _provider = SupportCategoriesService();

  Future<SupportCategoriesResponse> getSupportCategories() async {
    return _provider.getSupportCategories();
  }
}
