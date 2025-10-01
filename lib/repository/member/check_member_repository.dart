import '../../model/CheckMemberResponse.dart';
import '../../networking/services/member/check_member_service.dart';

class CheckMemberRepository {
  final _provider = CheckMemberService();

  Future<CheckMemberResponse> checkMemberExists(
      {required String mobile}) async {
    return _provider.checkMemberExists(mobile: mobile);
  }
}
