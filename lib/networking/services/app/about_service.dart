import '../../../model/TermsResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';
import '../../../model/ApiResponse.dart';

class AboutService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<TermsResponse> getAboutUs() async {
    final response = await _helper.get(Endpoints.aboutUs);
    return TermsResponse.fromJson(response);
  }
}
