import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FinishEngagementService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> finishEngagement(String hashcode) async {
    final Map<String, dynamic> body = {'hashcode': hashcode};
    final response = await _helper.post(Endpoints.finishEngagement, body);
    return response;
  }
}
