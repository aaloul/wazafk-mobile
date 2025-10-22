import '../../model/ApiResponse.dart';
import '../../model/FavoritesResponse.dart';
import '../../networking/services/favorite/favorite_members_service.dart';

class FavoriteMembersRepository {
  final _provider = FavoriteMembersService();

  Future<FavoritesResponse> getFavoriteMembers() async {
    return _provider.getFavoriteMembers();
  }
}
