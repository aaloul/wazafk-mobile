import '../../../model/InterestOptionsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class InterestOptionsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<InterestOptionsResponse> getInterestOptions() async {
    final response = await _helper.get(Endpoints.interestOptions);
    return response;
  }
}
