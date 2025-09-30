import '../../networking/services/package/save_package_service.dart';
import '../../model/ApiResponse.dart';

class SavePackageRepository {
  final _provider = SavePackageService();

  Future<ApiResponse> savePackage(
    String hashcode,
    Map<String, dynamic> data,
  ) async {
    return _provider.savePackage(hashcode, data);
  }
}
