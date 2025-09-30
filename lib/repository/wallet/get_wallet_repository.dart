import '../../model/ApiResponse.dart';
import '../../networking/services/wallet/get_wallet_service.dart';

class GetWalletRepository {
  final _provider = GetWalletService();

  Future<ApiResponse> getWallet() async {
    return _provider.getWallet();
  }
}
