import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class SaveJobService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> saveJob(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.saveJob, data);
    return response;
  }
}
