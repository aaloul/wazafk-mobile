import '../../model/ApiResponse.dart';
import '../../networking/services/wallet/payments_service.dart';

class PaymentsRepository {
  final _provider = PaymentsService();

  Future<ApiResponse> getPayments({Map<String, String>? filters}) async {
    return _provider.getPayments(filters: filters);
  }
}
