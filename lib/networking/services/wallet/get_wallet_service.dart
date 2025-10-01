import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class GetWalletService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> getWallet() async {
    final response = await _helper.get(Endpoints.wallet);
    return ApiResponse.fromJson(response);
  }
}
