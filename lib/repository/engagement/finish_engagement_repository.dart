import '../../model/ApiResponse.dart';
import '../../networking/services/engagement/finish_engagement_service.dart';

class FinishEngagementRepository {
  final _provider = FinishEngagementService();

  Future<ApiResponse> finishEngagement(String hashcode) async {
    return _provider.finishEngagement(hashcode);
  }
}
