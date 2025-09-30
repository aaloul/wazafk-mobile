import '../../model/ApiResponse.dart';
import '../../networking/services/rating/member_ratings_service.dart';

class MemberRatingsRepository {
  final _provider = MemberRatingsService();

  Future<ApiResponse> getMemberRatings(String memberHashcode) async {
    return _provider.getMemberRatings(memberHashcode);
  }
}
