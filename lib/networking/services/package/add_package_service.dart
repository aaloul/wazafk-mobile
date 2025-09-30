import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AddPackageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addPackage(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addPackage, data);
    return response;
  }
}
