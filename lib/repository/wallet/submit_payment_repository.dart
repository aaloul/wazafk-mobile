import '../../model/ApiResponse.dart';
import '../../networking/services/wallet/submit_payment_service.dart';

class SubmitPaymentRepository {
  final _provider = SubmitPaymentService();

  Future<ApiResponse> submitPayment(Map<String, dynamic> paymentData) async {
    return _provider.submitPayment(paymentData);
  }
}
