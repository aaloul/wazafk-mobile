import '../../model/ApiResponse.dart';
import '../../networking/services/account/account_service.dart';

class AccountRepository {
  final _provider = AccountService();

  Future<ApiResponse> login(String mobile, String password) async {
    return _provider.login(mobile, password);
  }

  Future<ApiResponse> register(Map<String, dynamic> data) async {
    return _provider.register(data);
  }

  Future<ApiResponse> forgotPasswordRequest(String mobile) async {
    return _provider.forgotPasswordRequest(mobile);
  }

  Future<ApiResponse> forgotPasswordConfirm(
    String mobile,
    String otp,
    String newPassword,
  ) async {
    return _provider.forgotPasswordConfirm(mobile, otp, newPassword);
  }

  Future<ApiResponse> sendOTP(String mobile) async {
    return _provider.sendOTP(mobile);
  }

  Future<ApiResponse> verifyOTP(String mobile, String otp) async {
    return _provider.verifyOTP(mobile, otp);
  }

  Future<ApiResponse> logout() async {
    return _provider.logout();
  }

  Future<ApiResponse> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    return _provider.changePassword(oldPassword, newPassword);
  }

  Future<ApiResponse> changeLanguage(String language) async {
    return _provider.changeLanguage(language);
  }

  Future<ApiResponse> changeNotificationPreferences(
    Map<String, bool> preferences,
  ) async {
    return _provider.changeNotificationPreferences(preferences);
  }

  Future<ApiResponse> getActivityLog() async {
    return _provider.getActivityLog();
  }

  Future<ApiResponse> deleteAccount() async {
    return _provider.deleteAccount();
  }
}
