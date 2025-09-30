import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class FaqsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getFaqs() async {
    final response = await _helper.get(Endpoints.faqs);
    return response;
  }
}
