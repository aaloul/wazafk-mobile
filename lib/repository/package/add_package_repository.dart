import '../../model/ApiResponse.dart';
import '../../networking/services/package/add_package_service.dart';

class AddPackageRepository {
  final _provider = AddPackageService();

  Future<ApiResponse> addPackage(Map<String, dynamic> data) async {
    return _provider.addPackage(data);
  }
}
