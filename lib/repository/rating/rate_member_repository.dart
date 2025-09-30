import '../../networking/services/rating/rate_member_service.dart';
import '../../model/ApiResponse.dart';

class RateMemberRepository {
  final _provider = RateMemberService();

  Future<ApiResponse> rateMember(
    String memberHashcode,
    Map<String, dynamic> ratingData,
  ) async {
    return _provider.rateMember(memberHashcode, ratingData);
  }
}
