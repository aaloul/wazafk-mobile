import '../../model/ApiResponse.dart';
import '../../networking/services/rating/rate_member_service.dart';

class RateMemberRepository {
  final _provider = RateMemberService();

  Future<ApiResponse> rateMember(
    Map<String, dynamic> ratingData,
  ) async {
    return _provider.rateMember(ratingData);
  }
}
