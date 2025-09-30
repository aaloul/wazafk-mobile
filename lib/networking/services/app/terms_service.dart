import 'package:wazafak_app/model/TermsResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class TermsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<TermsResponse> getTermsAndConditions() async {
    final response = await _helper.get(Endpoints.termsAndConditions);
    return response;
  }
}
