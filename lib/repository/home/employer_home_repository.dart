import '../../model/EmployerHomeResponse.dart';
import '../../networking/services/home/employer_home_service.dart';

class EmployerHomeRepository {
  final _provider = EmployerHomeService();

  Future<EmployerHomeResponse> getEmployerHome() async {
    return _provider.getEmployerHome();
  }
}
