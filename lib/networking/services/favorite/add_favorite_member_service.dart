import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AddFavoriteMemberService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> addFavoriteMember(String memberHashcode) async {
    final Map<String, dynamic> body = {'member_hashcode': memberHashcode};
    final response = await _helper.post(Endpoints.addFavoriteMember, body);
    return ApiResponse.fromJson(response);
  }
}
