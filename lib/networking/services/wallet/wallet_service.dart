import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class WalletService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getWallet() async {
    final response = await _helper.get(Endpoints.wallet);
    return response;
  }

  Future<ApiResponse> getWalletTransactions({
    Map<String, String>? filters,
  }) async {
    String url = Endpoints.walletTransactions;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return response;
  }

  Future<ApiResponse> submitPayment(Map<String, dynamic> paymentData) async {
    final response = await _helper.post(Endpoints.submitPayment, paymentData);
    return response;
  }

  Future<ApiResponse> getPayments({Map<String, String>? filters}) async {
    String url = Endpoints.payments;
    if (filters != null && filters.isNotEmpty) {
      final params = filters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url += '?$params';
    }
    final response = await _helper.get(url);
    return response;
  }

  Future<ApiResponse> chargeWalletWithPayment(Map<String, dynamic> data) async {
    final response = await _helper.post(
      Endpoints.chargeWalletWithPayment,
      data,
    );
    return response;
  }
}
