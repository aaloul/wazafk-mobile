import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AddJobService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addJob(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addJob, data);
    return response;
  }
}
