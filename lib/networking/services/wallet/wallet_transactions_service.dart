import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class WalletTransactionsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

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
}
