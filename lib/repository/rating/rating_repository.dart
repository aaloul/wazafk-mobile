import '../../networking/services/rating/rating_service.dart';
import '../../model/ApiResponse.dart';

class RatingRepository {
  final _provider = RatingService();

  Future<ApiResponse> getRatingCriteria() async {
    return _provider.getRatingCriteria();
  }

  Future<ApiResponse> rateMember(
    String memberHashcode,
    Map<String, dynamic> ratingData,
  ) async {
    return _provider.rateMember(memberHashcode, ratingData);
  }

  Future<ApiResponse> rateApp(Map<String, dynamic> ratingData) async {
    return _provider.rateApp(ratingData);
  }

  Future<ApiResponse> getMemberRatings(String memberHashcode) async {
    return _provider.getMemberRatings(memberHashcode);
  }
}
