import 'dart:convert';

LimitsResponse limitsResponseFromJson(String str) =>
    LimitsResponse.fromJson(json.decode(str));

class LimitsResponse {
  bool? success;
  String? message;
  AppLimits? data;

  LimitsResponse({this.success, this.message, this.data});

  factory LimitsResponse.fromJson(Map<String, dynamic> json) => LimitsResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? null
        : AppLimits.fromJson(Map<String, dynamic>.from(json["data"])),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

/// Posting limits and prices served by `app/limits`.
///
/// The payload is read by key with a small set of accepted spellings and the
/// design's values as the fallback, so a rename on the backend degrades to the
/// documented defaults instead of breaking the flow. [raw] keeps everything the
/// endpoint returned.
class AppLimits {
  AppLimits({Map<String, dynamic>? raw}) : raw = raw ?? <String, dynamic>{};

  final Map<String, dynamic> raw;

  factory AppLimits.fromJson(Map<String, dynamic> json) => AppLimits(raw: json);

  Map<String, dynamic> toJson() => raw;

  // ---- Skills (design p181) ------------------------------------------------

  /// Skills included at no cost — "First skill for free".
  int get freeSkills =>
      _int(['free_skills', 'nb_free_skills', 'skills_free', 'skill_free']) ?? 1;

  /// Most skills a service may carry — the "3 / 5" denominator.
  int get maxSkills =>
      _int(['max_skills', 'nb_max_skills', 'skills_limit', 'skills_max']) ?? 5;

  /// One-time charge per skill beyond [freeSkills].
  double get extraSkillPrice =>
      _double([
        'extra_skill_price',
        'skill_price',
        'extra_skill',
        'price_extra_skill',
      ]) ??
      1;

  // ---- Services (design p191 / p193) ---------------------------------------

  /// Monthly subscription that keeps a service live.
  double get serviceMonthlyPrice =>
      _double([
        'service_monthly_price',
        'service_price',
        'monthly_price',
        'service_subscription_price',
      ]) ??
      3;

  /// Free-trial length shown as "Renew at \$x/month after N days".
  int get serviceFreeDays =>
      _int(['service_free_days', 'free_days', 'trial_days']) ?? 90;

  // ---- Jobs (design p194) --------------------------------------------------

  /// Charge for publishing a job post.
  double get jobPostPrice =>
      _double([
            'job_post_price',
            'job_price',
            'post_price',
            'job_post_fee',
          ]) ??
      2;

  int? _int(List<String> keys) {
    final value = _raw(keys);
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  double? _double(List<String> keys) {
    final value = _raw(keys);
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  dynamic _raw(List<String> keys) {
    for (final key in keys) {
      if (raw.containsKey(key) && raw[key] != null) return raw[key];
    }
    return null;
  }
}
