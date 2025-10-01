import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class DeleteAccountService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> deleteAccount() async {
    final response = await _helper.delete(Endpoints.deleteAccount);
    return ApiResponse.fromJson(response);
  }
}
