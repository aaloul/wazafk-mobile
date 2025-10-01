import '../../../model/ApiResponse.dart';
import '../../api_base_helper.dart';

class PackageDetailService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getPackage(String hashcode) async {
    final response = await _helper.get('package/package/$hashcode');
    return ApiResponse.fromJson(response);
  }
}
