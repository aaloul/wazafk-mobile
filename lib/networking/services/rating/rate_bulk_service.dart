import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RateBulkService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> rateBulk(
    Map<String, dynamic> ratingData,
  ) async {
    final response = await _helper.post(Endpoints.rateBulk, ratingData);
    return ApiResponse.fromJson(response);
  }
}
