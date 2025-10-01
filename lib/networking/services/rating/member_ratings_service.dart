import '../../../model/ApiResponse.dart';
import '../../api_base_helper.dart';

class MemberRatingsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getMemberRatings(String memberHashcode) async {
    final response = await _helper.get('rating/memberRatings/$memberHashcode');
    return ApiResponse.fromJson(response);
  }
}
