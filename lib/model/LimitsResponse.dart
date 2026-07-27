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

/// Posting allowances and prices from `app/limits`:
///
/// ```json
/// "data": {
///   "skill":   {"free_limit": 2, "price": 2,  "used": 0, "chargeable": false},
///   "service": {"free_limit": 1, "price": 4,  "used": 7, "chargeable": true},
///   "package": {"free_limit": 1, "price": 6,  "used": 3, "chargeable": false},
///   "job":     {"free_limit": 1, "price": 10, "used": 4, "chargeable": true}
/// }
/// ```
class AppLimits {
  AppLimits({Map<String, dynamic>? raw}) : raw = raw ?? <String, dynamic>{};

  final Map<String, dynamic> raw;

  factory AppLimits.fromJson(Map<String, dynamic> json) => AppLimits(raw: json);

  Map<String, dynamic> toJson() => raw;

  /// Skills on a service — the first [EntityLimit.freeLimit] are included,
  /// each one after that costs [EntityLimit.price] once.
  EntityLimit get skill => _entry('skill', defaultFreeLimit: 1, defaultPrice: 1);

  /// Monthly subscription that keeps a service live.
  EntityLimit get service =>
      _entry('service', defaultFreeLimit: 1, defaultPrice: 3);

  /// Work package fee.
  EntityLimit get package =>
      _entry('package', defaultFreeLimit: 1, defaultPrice: 3);

  /// Job post fee.
  EntityLimit get job => _entry('job', defaultFreeLimit: 1, defaultPrice: 2);

  EntityLimit _entry(
    String key, {
    required int defaultFreeLimit,
    required double defaultPrice,
  }) {
    final value = raw[key];
    if (value is Map) {
      return EntityLimit.fromJson(Map<String, dynamic>.from(value));
    }
    return EntityLimit(freeLimit: defaultFreeLimit, price: defaultPrice);
  }
}

/// One row of `app/limits` — how many are free, what an extra one costs, how
/// many the member already has, and whether the next one is billed.
class EntityLimit {
  const EntityLimit({
    this.freeLimit = 0,
    this.price = 0,
    this.used = 0,
    this.chargeable = false,
  });

  final int freeLimit;
  final double price;
  final int used;

  /// The backend's verdict on whether the next one costs money.
  final bool chargeable;

  /// Free allowance still available (never negative).
  int get remainingFree =>
      freeLimit - used > 0 ? freeLimit - used : 0;

  factory EntityLimit.fromJson(Map<String, dynamic> json) => EntityLimit(
    freeLimit: _int(json['free_limit']) ?? 0,
    price: _double(json['price']) ?? 0,
    used: _int(json['used']) ?? 0,
    chargeable: json['chargeable'] == true,
  );

  Map<String, dynamic> toJson() => {
    'free_limit': freeLimit,
    'price': price,
    'used': used,
    'chargeable': chargeable,
  };

  static int? _int(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _double(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
