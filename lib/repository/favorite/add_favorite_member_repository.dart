import '../../model/ApiResponse.dart';
import '../../networking/services/favorite/add_favorite_member_service.dart';

class AddFavoriteMemberRepository {
  final _provider = AddFavoriteMemberService();

  Future<ApiResponse> addFavoriteMember(String memberHashcode) async {
    return _provider.addFavoriteMember(memberHashcode);
  }
}
