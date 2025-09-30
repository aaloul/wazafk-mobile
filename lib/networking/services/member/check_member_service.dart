import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class CheckMemberService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> checkMemberExists(String mobile) async {
    final response = await _helper.get(
      "${Endpoints.checkMemberExists}?mobile=$mobile",
    );
    return response;
  }
}
