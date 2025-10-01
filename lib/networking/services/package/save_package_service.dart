import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SavePackageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> savePackage(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.savePackage, data);
    return ApiResponse.fromJson(response);
  }
}
