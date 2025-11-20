import '../../../model/CoversationsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class CoversationsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<CoversationsResponse> getCoversations({
    int page = 1,
    int size = 20,
  }) async {
    final response = await _helper.get(
      '${Endpoints.coversations}?page=$page&size=$size',
    );
    return CoversationsResponse.fromJson(response);
  }
}
