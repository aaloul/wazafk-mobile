import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/add_favorite_service_service.dart';

class AddFavoriteServiceRepository {
  final _provider = AddFavoriteServiceService();

  Future<ApiResponse> addFavoriteService(String hashcode) async {
    return _provider.addFavoriteService(hashcode);
  }
}
