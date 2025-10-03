import '../../model/PaymentsResponse.dart';
import '../../networking/services/wallet/payments_service.dart';

class PaymentsRepository {
  final _provider = PaymentsService();

  Future<PaymentsResponse> getPayments({Map<String, String>? filters}) async {
    return _provider.getPayments(filters: filters);
  }
}
