import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/add_favorite_job_service.dart';
import '../../networking/services/favorite/add_favorite_package_service.dart';

class AddFavoritePackageRepository {
  final _provider = AddFavoritePackageService();

  Future<ApiResponse> addFavoritePackage(String hashcode) async {
    return _provider.addFavoritePackage(hashcode);
  }
}
