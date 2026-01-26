import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ClearSearchService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> clearSearch(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.clearSearchHistory, data);
    return ApiResponse.fromJson(response);
  }
}
