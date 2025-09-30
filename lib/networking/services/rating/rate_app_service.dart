import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class RateAppService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> rateApp(Map<String, dynamic> ratingData) async {
    final response = await _helper.post(Endpoints.rateApp, ratingData);
    return response;
  }
}
