import '../../../model/CheckMemberResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class CheckMemberService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<CheckMemberResponse> checkMemberExists(
      {required String mobile}) async {
    final Map<String, dynamic> body = {'mobile': mobile};

    final response = await _helper.post(Endpoints.checkMemberExists, body);
    return CheckMemberResponse.fromJson(response);
  }
}
