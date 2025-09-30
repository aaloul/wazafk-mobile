import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/engagement/accept_reject_engagement_change_request_service.dart';

class AcceptRejectEngagementChangeRequestRepository {
  final _provider = AcceptRejectEngagementChangeRequestService();

  Future<ApiResponse> acceptRejectEngagementChangeRequest(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    return _provider.acceptRejectEngagementChangeRequest(
      hashcode,
      accept,
      reason: reason,
    );
  }
}
