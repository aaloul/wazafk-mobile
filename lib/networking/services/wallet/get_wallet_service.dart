import 'package:wazafak_app/model/WalletResponse.dart';

import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class GetWalletService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<WalletResponse> getWallet() async {
    final response = await _helper.get(Endpoints.wallet);
    return WalletResponse.fromJson(response);
  }
}
