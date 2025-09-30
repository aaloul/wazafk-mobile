import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/accept_reject_engagement_service.dart';

class AcceptRejectEngagementRepository {
  final _provider = AcceptRejectEngagementService();

  Future<ApiResponse> acceptRejectEngagement(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    return _provider.acceptRejectEngagement(hashcode, accept, reason: reason);
  }
}
