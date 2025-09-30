import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/accept_reject_finish_engagement_service.dart';

class AcceptRejectFinishEngagementRepository {
  final _provider = AcceptRejectFinishEngagementService();

  Future<ApiResponse> acceptRejectFinishEngagement(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    return _provider.acceptRejectFinishEngagement(
      hashcode,
      accept,
      reason: reason,
    );
  }
}
