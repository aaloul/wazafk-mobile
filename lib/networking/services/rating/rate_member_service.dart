import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class RateMemberService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> rateMember(
    String memberHashcode,
    Map<String, dynamic> ratingData,
  ) async {
    ratingData['member_hashcode'] = memberHashcode;
    final response = await _helper.post(Endpoints.rateMember, ratingData);
    return response;
  }
}
