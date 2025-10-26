import '../../../model/FreelancerHomeResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FreelancerHomeService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<FreelancerHomeResponse> getFreelancerHome() async {
    final response = await _helper.get(Endpoints.freelancerHome);
    return FreelancerHomeResponse.fromJson(response);
  }
}
