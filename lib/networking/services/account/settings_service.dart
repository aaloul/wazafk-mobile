import '../../../model/ApiResponse.dart';
import '../../Endpoints.dart';
import '../../api_base_helper.dart';

class SettingsService {
  final ApiBaseHelper _helper = ApiBaseHelper();

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
}
