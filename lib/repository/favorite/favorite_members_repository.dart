import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/favorite_members_service.dart';

class FavoriteMembersRepository {
  final _provider = FavoriteMembersService();

  Future<ApiResponse> getFavoriteMembers() async {
    return _provider.getFavoriteMembers();
  }
}
