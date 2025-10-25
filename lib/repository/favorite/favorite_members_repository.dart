import '../../model/ApiResponse.dart';
import '../../model/FavoritesResponse.dart';
import '../../networking/services/favorite/add_favorite_member_service.dart';
import '../../networking/services/favorite/favorite_members_service.dart';
import '../../networking/services/favorite/remove_favorite_member_service.dart';

class FavoriteMembersRepository {
  final _provider = FavoriteMembersService();
  final _addFavoriteProvider = AddFavoriteMemberService();
  final _removeFavoriteProvider = RemoveFavoriteMemberService();

  Future<FavoritesResponse> getFavoriteMembers() async {
    return _provider.getFavoriteMembers();
  }

  Future<ApiResponse> addFavoriteMember(String memberHashcode) async {
    return _addFavoriteProvider.addFavoriteMember(memberHashcode);
  }

  Future<ApiResponse> removeFavoriteMember(String memberHashcode) async {
    return _removeFavoriteProvider.removeFavoriteMember(memberHashcode);
  }
}
