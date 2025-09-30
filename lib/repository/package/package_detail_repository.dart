import '../../model/ApiResponse.dart';
import '../../networking/services/package/package_detail_service.dart';

class PackageDetailRepository {
  final _provider = PackageDetailService();

  Future<ApiResponse> getPackage(String hashcode) async {
    return _provider.getPackage(hashcode);
  }
}
