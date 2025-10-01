import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class InterestsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> saveInterests(List<String> interests) async {
    final Map<String, dynamic> body = {'interests': interests};
    final response = await _helper.post(Endpoints.saveInterests, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getInterests() async {
    final response = await _helper.get(Endpoints.interests);
    return ApiResponse.fromJson(response);
  }
}
