import '../../model/ApiResponse.dart';
import '../../networking/services/member/check_member_service.dart';

class CheckMemberRepository {
  final _provider = CheckMemberService();

  Future<ApiResponse> checkMemberExists(String mobile) async {
    return _provider.checkMemberExists(mobile);
  }
}
