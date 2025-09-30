import 'package:wazafak_app/model/ApiResponse.dart';

import '../../networking/services/app/faqs_service.dart';

class FaqsRepository {
  final _provider = FaqsService();

  Future<ApiResponse> getFaqs() async {
    return _provider.getFaqs();
  }
}
