import '../../model/TermsResponse.dart';
import '../../networking/services/app/terms_service.dart';

class TermsRepository {
  final _provider = TermsService();

  Future<TermsResponse> getTermsAndConditions() async {
    return _provider.getTermsAndConditions();
  }
}
