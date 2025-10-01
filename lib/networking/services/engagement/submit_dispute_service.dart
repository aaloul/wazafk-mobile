import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SubmitDisputeService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> submitDispute(
    String hashcode,
    Map<String, dynamic> disputeData,
  ) async {
    disputeData['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.submitDispute, disputeData);
    return ApiResponse.fromJson(response);
  }
}
