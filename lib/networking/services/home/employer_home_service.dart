import 'package:wazafak_app/model/EmployerHomeResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class EmployerHomeService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<EmployerHomeResponse> getEmployerHome() async {
    final response = await _helper.get(Endpoints.employerHome);
    return EmployerHomeResponse.fromJson(response);
  }
}
