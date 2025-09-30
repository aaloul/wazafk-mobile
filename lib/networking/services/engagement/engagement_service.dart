import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class EngagementService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> submitEngagement(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.submitEngagement, data);
    return response;
  }

  Future<ApiResponse> acceptRejectEngagement(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'accept': accept};
    if (reason != null) body['reason'] = reason;
    final response = await _helper.post(Endpoints.acceptRejectEngagement, body);
    return response;
  }

  Future<ApiResponse> submitEngagementChangeRequest(
    String hashcode,
    Map<String, dynamic> changes,
  ) async {
    changes['hashcode'] = hashcode;
    final response = await _helper.post(
      Endpoints.submitEngagementChangeRequest,
      changes,
    );
    return response;
  }

  Future<ApiResponse> acceptRejectEngagementChangeRequest(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'accept': accept};
    if (reason != null) body['reason'] = reason;
    final response = await _helper.post(
      Endpoints.acceptRejectEngagementChangeRequest,
      body,
    );
    return response;
  }

  Future<ApiResponse> finishEngagement(String hashcode) async {
    final Map<String, dynamic> body = {'hashcode': hashcode};
    final response = await _helper.post(Endpoints.finishEngagement, body);
    return response;
  }

  Future<ApiResponse> acceptRejectFinishEngagement(
    String hashcode,
    bool accept, {
    String? reason,
  }) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'accept': accept};
    if (reason != null) body['reason'] = reason;
    final response = await _helper.post(
      Endpoints.acceptRejectFinishEngagement,
      body,
    );
    return response;
  }

  Future<ApiResponse> submitDispute(
    String hashcode,
    Map<String, dynamic> disputeData,
  ) async {
    disputeData['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.submitDispute, disputeData);
    return response;
  }

  Future<ApiResponse> getEngagements({Map<String, String>? filters}) async {
    String url = Endpoints.engagements;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return response;
  }

  Future<ApiResponse> getEngagement(String hashcode) async {
    final response = await _helper.get('engagement/engagement/$hashcode');
    return response;
  }
}
