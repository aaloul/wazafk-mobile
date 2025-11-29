import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/engagement/accept_reject_engagement_change_request_service.dart';

class AcceptRejectEngagementChangeRequestRepository {
  final _provider = AcceptRejectEngagementChangeRequestService();

  Future<ApiResponse> acceptRejectEngagementChangeRequest({
    required String hashcode,
    required bool accept,
  }) async {
    return _provider.acceptRejectEngagementChangeRequest(
      hashcode: hashcode,
      accept: accept,
    );
  }
}
