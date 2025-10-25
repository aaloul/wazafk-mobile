import '../../../model/EmployerHomeResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FreelancerHomeService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<HomeFreelancer> getFreelancerHome() async {
    final response = await _helper.get(Endpoints.freelancerHome);
    return HomeFreelancer.fromJson(response);
  }
}
