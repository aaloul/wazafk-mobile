import '../../model/ApiResponse.dart';
import '../../networking/services/member/interests_service.dart';

class InterestsRepository {
  final _provider = InterestsService();

  Future<ApiResponse> saveInterests(List<String> interests) async {
    return _provider.saveInterests(interests);
  }

  Future<ApiResponse> getInterests() async {
    return _provider.getInterests();
  }
}
