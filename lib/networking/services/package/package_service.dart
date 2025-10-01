import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class PackageService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addPackage(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.addPackage, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> savePackage(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    data['hashcode'] = hashcode;
    final response = await _helper.post(Endpoints.savePackage, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> updatePackageStatus(String hashcode, int status) async {
    final Map<String, dynamic> body = {'hashcode': hashcode, 'status': status};
    final response = await _helper.post(Endpoints.packageStatus, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getPackages({Map<String, String>? filters}) async {
    String url = Endpoints.packages;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getPackage(String hashcode) async {
    final response = await _helper.get('package/package/$hashcode');
    return ApiResponse.fromJson(response);
  }
}
