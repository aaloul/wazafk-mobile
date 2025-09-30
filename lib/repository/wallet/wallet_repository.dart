import '../../model/ApiResponse.dart';
import '../../networking/services/wallet/wallet_service.dart';

class WalletRepository {
  final _provider = WalletService();

  Future<ApiResponse> getWallet() async {
    return _provider.getWallet();
  }

  Future<ApiResponse> getWalletTransactions({
    Map<String, String>? filters,
  }) async {
    return _provider.getWalletTransactions(filters: filters);
  }

  Future<ApiResponse> submitPayment(Map<String, dynamic> paymentData) async {
    return _provider.submitPayment(paymentData);
  }

  Future<ApiResponse> getPayments({Map<String, String>? filters}) async {
    return _provider.getPayments(filters: filters);
  }

  Future<ApiResponse> chargeWalletWithPayment(Map<String, dynamic> data) async {
    return _provider.chargeWalletWithPayment(data);
  }
}
