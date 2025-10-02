import '../../model/FAQSResponse.dart';
import '../../networking/services/app/faqs_service.dart';

class FaqsRepository {
  final _provider = FaqsService();

  Future<FaqsResponse> getFaqs() async {
    return _provider.getFaqs();
  }
}
