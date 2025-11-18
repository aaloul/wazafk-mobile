import '../../model/EmployerHomeResponse.dart';
import '../../networking/services/home/employer_home_service.dart';

class EmployerHomeRepository {
  final _provider = EmployerHomeService();

  Future<EmployerHomeResponse> getEmployerHome(
      {Map<String, String>? filters}) async {
    return _provider.getEmployerHome(filters: filters);
  }
}
