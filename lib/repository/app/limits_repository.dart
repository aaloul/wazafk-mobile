import 'package:wazafak_app/model/LimitsResponse.dart';

import '../../networking/services/app/limits_service.dart';

class LimitsRepository {
  final _provider = LimitsService();

  Future<LimitsResponse> getLimits() async {
    return _provider.getLimits();
  }
}

/// Session-wide cache for `app/limits` so the posting flows can read prices and
/// caps without re-fetching on every screen. Falls back to [AppLimits]'s
/// defaults while the first call is in flight or if it fails.
class AppLimitsCache {
  AppLimitsCache._();

  static final _repository = LimitsRepository();
  static AppLimits _current = AppLimits();
  static Future<AppLimits>? _inFlight;
  static bool _loaded = false;

  /// Last known limits — safe to read synchronously at any point.
  static AppLimits get current => _current;

  /// Whether the values come from the API rather than the built-in fallbacks.
  /// Anything that decides "is this free?" should wait for this.
  static bool get isLoaded => _loaded;

  static Future<AppLimits> load({bool forceRefresh = false}) {
    if (!forceRefresh && _inFlight != null) return _inFlight!;

    final future = _fetch();
    _inFlight = future;
    return future;
  }

  static Future<AppLimits> _fetch() async {
    try {
      final response = await _repository.getLimits();
      if (response.success == true && response.data != null) {
        _current = response.data!;
        _loaded = true;
      }
    } catch (_) {
      // Keep whatever we had; the defaults match the design.
    }
    return _current;
  }
}
