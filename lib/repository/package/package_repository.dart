import '../../model/ApiResponse.dart';
import '../../networking/services/package/package_service.dart';

class PackageRepository {
  final _provider = PackageService();

  Future<ApiResponse> addPackage(Map<String, dynamic> data) async {
    return _provider.addPackage(data);
  }

  Future<ApiResponse> savePackage(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.savePackage(hashcode, data);
  }

  Future<ApiResponse> updatePackageStatus(String hashcode, int status) async {
    return _provider.updatePackageStatus(hashcode, status);
  }

  Future<ApiResponse> getPackages({Map<String, String>? filters}) async {
    return _provider.getPackages(filters: filters);
  }

  Future<ApiResponse> getPackage(String hashcode) async {
    return _provider.getPackage(hashcode);
  }
}
