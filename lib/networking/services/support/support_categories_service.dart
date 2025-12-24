import '../../../model/SupportCategoriesResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SupportCategoriesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SupportCategoriesResponse> getSupportCategories() async {
    final response = await _helper.get(Endpoints.supportCategories);
    return SupportCategoriesResponse.fromJson(response);
  }
}
