import '../../model/ApiResponse.dart';
import '../../networking/services/member/members_service.dart';

class MembersRepository {
  final _provider = MembersService();

  Future<ApiResponse> getMembers({Map<String, String>? filters}) async {
    return _provider.getMembers(filters: filters);
  }
}
