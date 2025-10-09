import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class PasswordService {
  final ApiBaseHelper _helper = ApiBaseHelper();


  Future<ApiResponse> forgotPasswordConfirm(
    String mobile,
    String resetToken,
    String newPassword,
  ) async {
    final Map<String, dynamic> body = {
      'mobile': mobile,
      'reset_token': resetToken,
      'password': newPassword,
    };
    final response = await _helper.post(Endpoints.forgotPasswordConfirm, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final Map<String, dynamic> body = {
      'current_password': oldPassword,
      'new_password': newPassword,
    };
    final response = await _helper.post(Endpoints.changePassword, body);
    return ApiResponse.fromJson(response);
  }
}
