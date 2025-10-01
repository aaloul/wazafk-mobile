import '../../../model/TermsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class PrivacyService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<TermsResponse> getPrivacyPolicy() async {
    final response = await _helper.get(Endpoints.privacyPolicy);
    return TermsResponse.fromJson(response);
  }
}
