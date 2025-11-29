import '../../model/EngagementsResponse.dart';
import '../../networking/services/engagement/engagement_detail_service.dart';

class EngagementDetailRepository {
  final _provider = EngagementDetailService();

  Future<EngagementsResponse> getEngagement(String hashcode) async {
    return _provider.getEngagement(hashcode);
  }
}
