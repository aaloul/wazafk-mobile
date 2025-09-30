import '../../model/ApiResponse.dart';
import '../../networking/services/wallet/charge_wallet_service.dart';

class ChargeWalletRepository {
  final _provider = ChargeWalletService();

  Future<ApiResponse> chargeWalletWithPayment(Map<String, dynamic> data) async {
    return _provider.chargeWalletWithPayment(data);
  }
}
