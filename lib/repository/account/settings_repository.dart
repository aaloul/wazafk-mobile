import '../../model/ApiResponse.dart';
import '../../networking/services/account/settings_service.dart';

class SettingsRepository {
  final _provider = SettingsService();

  Future<ApiResponse> changeLanguage(String language) async {
    return _provider.changeLanguage(language);
  }

  Future<ApiResponse> changeNotificationPreferences(
    Map<String, int> preferences,
  ) async {
    return _provider.changeNotificationPreferences(preferences);
  }
}
