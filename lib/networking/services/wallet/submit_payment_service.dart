import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SubmitPaymentService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> submitPayment(Map<String, dynamic> paymentData) async {
    final response = await _helper.post(Endpoints.submitPayment, paymentData);
    return response;
  }
}
