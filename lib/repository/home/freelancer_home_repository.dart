import '../../model/EmployerHomeResponse.dart';
import '../../networking/services/home/freelancer_home_service.dart';

class FreelancerHomeRepository {
  final _provider = FreelancerHomeService();

  Future<HomeFreelancer> getFreelancerHome() async {
    return _provider.getFreelancerHome();
  }
}
