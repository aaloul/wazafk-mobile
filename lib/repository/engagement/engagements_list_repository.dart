import '../../model/EngagementssResponse.dart';
import '../../networking/services/engagement/engagements_list_service.dart';

class EngagementsListRepository {
  final _provider = EngagementsListService();

  Future<EngagementsResponse> getEngagements(
      {Map<String, String>? filters}) async {
    return _provider.getEngagements(filters: filters);
  }
}
