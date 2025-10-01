import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class AccountService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<ApiResponse> login(String mobile, String password) async {
    final Map<String, dynamic> body = {'mobile': mobile, 'password': password};
    final response = await _helper.post(Endpoints.login, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> register(Map<String, dynamic> data) async {
    final response = await _helper.post(Endpoints.register, data);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> forgotPasswordRequest(String mobile) async {
    final Map<String, dynamic> body = {'mobile': mobile};
    final response = await _helper.post(Endpoints.forgotPasswordRequest, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> forgotPasswordConfirm(
    String mobile,
    String otp,
    String newPassword,
  ) async {
    final Map<String, dynamic> body = {
      'mobile': mobile,
      'otp': otp,
      'new_password': newPassword,
    };
    final response = await _helper.post(Endpoints.forgotPasswordConfirm, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> sendOTP(String mobile) async {
    final Map<String, dynamic> body = {'mobile': mobile};
    final response = await _helper.post(Endpoints.sendOTP, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> verifyOTP(String mobile, String otp) async {
    final Map<String, dynamic> body = {'mobile': mobile, 'otp': otp};
    final response = await _helper.post(Endpoints.verifyOTP, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> logout() async {
    final response = await _helper.post(Endpoints.logout, {});
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final Map<String, dynamic> body = {
      'old_password': oldPassword,
      'new_password': newPassword,
    };
    final response = await _helper.post(Endpoints.changePassword, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> changeLanguage(String language) async {
    final Map<String, dynamic> body = {'language': language};
    final response = await _helper.post(Endpoints.changeLanguage, body);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> changeNotificationPreferences(
    Map<String, bool> preferences,
  ) async {
    final response = await _helper.post(
      Endpoints.changeNotificationPreferences,
      preferences,
    );
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> getActivityLog() async {
    final response = await _helper.get(Endpoints.activityLog);
    return ApiResponse.fromJson(response);
  }

  Future<ApiResponse> deleteAccount() async {
    final response = await _helper.delete(Endpoints.deleteAccount);
    return ApiResponse.fromJson(response);
  }
}
