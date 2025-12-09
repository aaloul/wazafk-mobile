import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/submit_engagement_service.dart';

class SubmitEngagementRepository {
  final _provider = SubmitEngagementService();

  Future<ApiResponse> submitEngagement(Map<String, dynamic> data) async {
    return _provider.submitEngagement(data);
  }
}
