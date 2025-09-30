import '../../model/ApiResponse.dart';
import '../../networking/services/wallet/wallet_transactions_service.dart';

class WalletTransactionsRepository {
  final _provider = WalletTransactionsService();

  Future<ApiResponse> getWalletTransactions({
    Map<String, String>? filters,
  }) async {
    return _provider.getWalletTransactions(filters: filters);
  }
}
