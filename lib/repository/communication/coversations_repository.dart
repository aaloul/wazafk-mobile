import '../../model/CoversationsResponse.dart';
import '../../networking/services/communication/coversations_service.dart';

class CoversationsRepository {
  final _provider = CoversationsService();

  Future<CoversationsResponse> getCoversations({
    int page = 1,
    int size = 20,
  }) async {
    return _provider.getCoversations(page: page, size: size);
  }
}
