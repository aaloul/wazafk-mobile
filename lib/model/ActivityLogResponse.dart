// Typed wrapper over the `account/activityLog` LOGIN entries used by the
// "Where you're logged in" screen.
//
// NOTE: the backend response shape isn't documented, so [LoginSession] parses
// defensively across common field names. Confirm/trim the key lists once the
// real payload is known.

import 'package:intl/intl.dart';

class ActivityLogResponse {
  bool? success;
  String? message;
  List<LoginSession>? data;

  ActivityLogResponse({this.success, this.message, this.data});

  factory ActivityLogResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    List<LoginSession> list = [];
    if (raw is List) {
      list = raw
          .whereType<Map<String, dynamic>>()
          .map(LoginSession.fromJson)
          .toList();
    } else if (raw is Map && raw['list'] is List) {
      list = (raw['list'] as List)
          .whereType<Map<String, dynamic>>()
          .map(LoginSession.fromJson)
          .toList();
    }
    return ActivityLogResponse(
      success: json['success'],
      message: json['message'],
      data: list,
    );
  }
}

class LoginSession {
  final String device;
  final String location;
  final String dateTimeLabel;
  final bool isCurrent;
  final String? hashcode;

  LoginSession({
    required this.device,
    required this.location,
    required this.dateTimeLabel,
    required this.isCurrent,
    this.hashcode,
  });

  factory LoginSession.fromJson(Map<String, dynamic> j) {
    String pick(List<String> keys) {
      for (final k in keys) {
        final v = j[k];
        if (v != null &&
            v.toString().trim().isNotEmpty &&
            v.toString() != 'null') {
          return v.toString().trim();
        }
      }
      return '';
    }

    final device =
        pick(['device', 'device_name', 'device_model', 'model', 'agent', 'user_agent']);

    var location = pick(['location', 'ip_location', 'place', 'city_country']);
    if (location.isEmpty) {
      final city = pick(['city']);
      final country = pick(['country']);
      location = [city, country].where((s) => s.isNotEmpty).join(', ');
    }

    final rawDate = pick(
        ['created_at', 'datetime', 'login_at', 'logged_in_at', 'date', 'last_active']);
    String dateLabel = '';
    if (rawDate.isNotEmpty) {
      final dt = DateTime.tryParse(rawDate);
      dateLabel = dt != null
          ? '${DateFormat('dd-MM-yyyy').format(dt)} at ${DateFormat('h:mm a').format(dt)}'
          : rawDate;
    }

    final currentRaw = pick(['is_current', 'current']).toLowerCase();
    final isCurrent = j['is_current'] == true ||
        j['current'] == true ||
        currentRaw == '1' ||
        currentRaw == 'true';

    final hashcode = pick(['hashcode', 'id', 'session_id', 'token_id']);

    return LoginSession(
      device: device.isEmpty ? 'Unknown device' : device,
      location: location,
      dateTimeLabel: dateLabel,
      isCurrent: isCurrent,
      hashcode: hashcode.isEmpty ? null : hashcode,
    );
  }
}
