import '../../model/ApiResponse.dart';
import '../../networking/services/package/package_status_service.dart';

class PackageStatusRepository {
  final _provider = PackageStatusService();

  Future<ApiResponse> updatePackageStatus(String hashcode, int status) async {
    return _provider.updatePackageStatus(hashcode, status);
  }
}
