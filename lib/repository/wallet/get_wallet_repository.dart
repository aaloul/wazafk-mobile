import '../../model/WalletResponse.dart';
import '../../networking/services/wallet/get_wallet_service.dart';

class GetWalletRepository {
  final _provider = GetWalletService();

  Future<WalletResponse> getWallet() async {
    return _provider.getWallet();
  }
}
