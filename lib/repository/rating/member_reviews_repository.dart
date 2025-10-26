import '../../model/MemberReviewsResponse.dart';
import '../../networking/services/rating/member_reviews_service.dart';

class MemberReviewsRepository {
  final _provider = MemberReviewsService();

  Future<MemberReviewsResponse> getMemberReviews({
    Map<String, String>? filters,
  }) async {
    return _provider.getMemberReviews(filters: filters);
  }
}
