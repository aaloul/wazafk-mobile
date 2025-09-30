import '../../model/TermsResponse.dart';
import '../../networking/services/app/about_service.dart';

class AboutRepository {
  final _provider = AboutService();

  Future<TermsResponse> getAboutUs() async {
    return _provider.getAboutUs();
  }
}
