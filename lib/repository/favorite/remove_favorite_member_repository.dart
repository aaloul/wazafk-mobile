import '../../networking/services/favorite/remove_favorite_member_service.dart';
import '../../model/ApiResponse.dart';

class RemoveFavoriteMemberRepository {
  final _provider = RemoveFavoriteMemberService();

  Future<ApiResponse> removeFavoriteMember(String memberHashcode) async {
    return _provider.removeFavoriteMember(memberHashcode);
  }
}
