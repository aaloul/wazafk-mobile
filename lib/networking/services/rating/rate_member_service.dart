import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RateMemberService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> rateMember(
    Map<String, dynamic> ratingData,
  ) async {
    final response = await _helper.post(Endpoints.rateMember, ratingData);
    return ApiResponse.fromJson(response);
  }
}
