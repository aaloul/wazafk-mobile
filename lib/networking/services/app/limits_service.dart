import 'package:wazafak_app/model/LimitsResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class LimitsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<LimitsResponse> getLimits() async {
    final response = await _helper.get(Endpoints.limits);
    return LimitsResponse.fromJson(response);
  }
}
