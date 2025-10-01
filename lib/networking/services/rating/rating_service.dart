import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class RatingService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getRatingCriteria() async {
    final response = await _helper.get(Endpoints.ratingCriteria);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> rateMember(
    String memberHashcode,
    Map<String, dynamic> ratingData,
  ) async {
    ratingData['member_hashcode'] = memberHashcode;
    final response = await _helper.post(Endpoints.rateMember, ratingData);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> rateApp(Map<String, dynamic> ratingData) async {
    final response = await _helper.post(Endpoints.rateApp, ratingData);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getMemberRatings(String memberHashcode) async {
    final response = await _helper.get('rating/memberRatings/$memberHashcode');
    return ApiResponse.fromJson(response);
  }
}
