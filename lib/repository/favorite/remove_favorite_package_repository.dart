import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/remove_favorite_package_service.dart';

class RemoveFavoritePackageRepository {
  final _provider = RemoveFavoritePackageService();

  Future<ApiResponse> removeFavoritePackage(String hashcode) async {
    return _provider.removeFavoritePackage(hashcode);
  }
}
