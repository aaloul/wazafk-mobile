import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/remove_favorite_service_service.dart';

class RemoveFavoriteServiceRepository {
  final _provider = RemoveFavoriteServiceService();

  Future<ApiResponse> removeFavoriteService(String hashcode) async {
    return _provider.removeFavoriteService(hashcode);
  }
}
