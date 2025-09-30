import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class MarkNotificationReadService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> markNotificationRead(String hashcode) async {
    final Map<String, dynamic> body = {'hashcode': hashcode};
    final response = await _helper.post(Endpoints.markNotificationRead, body);
    return response;
  }
}
