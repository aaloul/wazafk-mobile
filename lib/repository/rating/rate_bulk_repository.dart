import '../../model/ApiResponse.dart';
import '../../networking/services/rating/rate_bulk_service.dart';

class RateBulkRepository {
  final _provider = RateBulkService();

  Future<ApiResponse> rateBulk(
    Map<String, dynamic> ratingData,
  ) async {
    return _provider.rateBulk(ratingData);
  }
}
