import '../../model/TermsResponse.dart';
import '../../networking/services/app/privacy_service.dart';

class PrivacyRepository {
  final _provider = PrivacyService();

  Future<TermsResponse> getPrivacyPolicy() async {
    return _provider.getPrivacyPolicy();
  }
}
