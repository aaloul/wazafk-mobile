import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/engagement_service.dart';

class EngagementRepository {
  final _provider = EngagementService();

  Future<ApiResponse> submitEngagement(Map<String, dynamic> data) async {
    return _provider.submitEngagement(data);
  }

  Future<ApiResponse> acceptRejectEngagement(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    return _provider.acceptRejectEngagement(hashcode, accept, reason: reason);
  }

  Future<ApiResponse> submitEngagementChangeRequest(
    String hashcode,
    Map<String, dynamic> changes,
  ) async {
    return _provider.submitEngagementChangeRequest(hashcode, changes);
  }

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

  Future<ApiResponse> finishEngagement(String hashcode) async {
    return _provider.finishEngagement(hashcode);
  }

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

  Future<ApiResponse> submitDispute(
    String hashcode,
    Map<String, dynamic> disputeData,
  ) async {
    return _provider.submitDispute(hashcode, disputeData);
  }

  Future<ApiResponse> getEngagements({Map<String, String>? filters}) async {
    return _provider.getEngagements(filters: filters);
  }

  Future<ApiResponse> getEngagement(String hashcode) async {
    return _provider.getEngagement(hashcode);
  }
}
