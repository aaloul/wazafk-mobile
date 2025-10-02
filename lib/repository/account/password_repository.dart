import '../../model/ApiResponse.dart';
import '../../networking/services/account/password_service.dart';

class PasswordRepository {
  final _provider = PasswordService();

  Future<ApiResponse> forgotPasswordRequest(String mobile) async {
    return _provider.forgotPasswordRequest(mobile);
  }

  Future<ApiResponse> forgotPasswordConfirm(
    String mobile,
    String resetToken,
    String newPassword,
  ) async {
    return _provider.forgotPasswordConfirm(mobile, resetToken, newPassword);
  }

  Future<ApiResponse> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    return _provider.changePassword(oldPassword, newPassword);
  }
}
