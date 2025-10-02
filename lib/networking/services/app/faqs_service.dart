import '../../../model/FAQSResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FaqsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<FaqsResponse> getFaqs() async {
    final response = await _helper.get(Endpoints.faqs);
    return FaqsResponse.fromJson(response);
  }
}
