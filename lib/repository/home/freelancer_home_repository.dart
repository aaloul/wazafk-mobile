import '../../model/FreelancerHomeResponse.dart';
import '../../networking/services/home/freelancer_home_service.dart';

class FreelancerHomeRepository {
  final _provider = FreelancerHomeService();

  Future<FreelancerHomeResponse> getFreelancerHome() async {
    return _provider.getFreelancerHome();
  }
}
