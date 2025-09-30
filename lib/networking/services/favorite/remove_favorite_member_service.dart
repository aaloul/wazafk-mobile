import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class RemoveFavoriteMemberService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> removeFavoriteMember(String memberHashcode) async {
    final Map<String, dynamic> body = {'member_hashcode': memberHashcode};
    final response = await _helper.post(Endpoints.removeFavoriteMember, body);
    return response;
  }
}
