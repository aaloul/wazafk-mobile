import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FavoriteMembersService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getFavoriteMembers() async {
    final response = await _helper.get(Endpoints.favoriteMembers);
    return ApiResponse.fromJson(response);
  }
}
