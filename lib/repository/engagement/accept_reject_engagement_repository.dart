import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/accept_reject_engagement_service.dart';

class AcceptRejectEngagementRepository {
  final _provider = AcceptRejectEngagementService();

  Future<ApiResponse> acceptRejectEngagement({
    required String hashcode,
    required bool accept,
  }) async {
    return _provider.acceptRejectEngagement(hashcode: hashcode, accept: accept);
  }
}
