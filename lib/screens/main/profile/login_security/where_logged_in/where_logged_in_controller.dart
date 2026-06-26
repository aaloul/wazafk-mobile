import 'package:get/get.dart';
import 'package:wazafak_app/model/ActivityLogResponse.dart';
import 'package:wazafak_app/repository/account/activity_log_repository.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

class WhereLoggedInController extends GetxController {
  final _repository = ActivityLogRepository();

  var isLoading = false.obs;
  var currentSession = Rxn<LoginSession>();
  var otherSessions = <LoginSession>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    try {
      isLoading.value = true;
      final response = await _repository.getLoginSessions();
      final all = response.data ?? [];
      if (all.isEmpty) {
        currentSession.value = null;
        otherSessions.clear();
        return;
      }
      final idx = all.indexWhere((s) => s.isCurrent);
      if (idx >= 0) {
        currentSession.value = all[idx];
        otherSessions.value = [...all]..removeAt(idx);
      } else {
        // No explicit "current" flag — treat the most recent entry as current.
        currentSession.value = all.first;
        otherSessions.value = all.skip(1).toList();
      }
    } catch (e) {
      print('Error loading login sessions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Logs out a specific other device.
  /// NOTE: the backend currently exposes only a generic `account/logout`
  /// (no per-device logout), so this surfaces an info message until a
  /// session-scoped logout endpoint is available.
  void logoutSession(LoginSession session) {
    constants.showSnackBar(
      Resources.of(Get.context!).strings.deviceLogoutUnavailable,
      SnackBarStatus.INFO,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
