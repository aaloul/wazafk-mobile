import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/submit_engagement_change_request_service.dart';

class SubmitEngagementChangeRequestRepository {
  final _provider = SubmitEngagementChangeRequestService();

  Future<ApiResponse> submitEngagementChangeRequest(
    String hashcode,
    Map<String, dynamic> changes,
  ) async {
    return _provider.submitEngagementChangeRequest(hashcode, changes);
  }
}
