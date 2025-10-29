import '../../model/ApiResponse.dart';
import '../../model/FavoritesResponse.dart';
import '../../networking/services/favorite/add_favorite_member_service.dart';
import '../../networking/services/favorite/favorites_service.dart';
import '../../networking/services/favorite/remove_favorite_member_service.dart';

class FavoriteMembersRepository {
  final _provider = FavoritesService();
  final _addFavoriteProvider = AddFavoriteMemberService();
  final _removeFavoriteProvider = RemoveFavoriteMemberService();

  Future<FavoritesResponse> getFavorites() async {
    return _provider.getFavorites();
  }

  Future<ApiResponse> addFavoriteMember(String memberHashcode) async {
    return _addFavoriteProvider.addFavoriteMember(memberHashcode);
  }

  Future<ApiResponse> removeFavoriteMember(String memberHashcode) async {
    return _removeFavoriteProvider.removeFavoriteMember(memberHashcode);
  }
}
