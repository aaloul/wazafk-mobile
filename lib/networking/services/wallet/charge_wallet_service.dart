import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class ChargeWalletService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> chargeWalletWithPayment(Map<String, dynamic> data) async {
    final response = await _helper.post(
      Endpoints.chargeWalletWithPayment,
      data,
    );
    return response;
  }
}
