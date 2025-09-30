import '../../model/ApiResponse.dart';
import '../../networking/services/rating/rate_app_service.dart';

class RateAppRepository {
  final _provider = RateAppService();

  Future<ApiResponse> rateApp(Map<String, dynamic> ratingData) async {
    return _provider.rateApp(ratingData);
  }
}
