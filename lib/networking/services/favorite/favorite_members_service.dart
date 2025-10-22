import '../../../model/ApiResponse.dart';
import '../../../model/FavoritesResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FavoriteMembersService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<FavoritesResponse> getFavoriteMembers() async {
    final response = await _helper.get(Endpoints.favoriteMembers);
    return FavoritesResponse.fromJson(response);
  }
}
