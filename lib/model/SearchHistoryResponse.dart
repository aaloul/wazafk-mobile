// To parse this JSON data, do
//
//     final searchHistoryResponse = searchHistoryResponseFromJson(jsonString);

import 'dart:convert';

SearchHistoryResponse searchHistoryResponseFromJson(String str) => SearchHistoryResponse.fromJson(json.decode(str));

String searchHistoryResponseToJson(SearchHistoryResponse data) => json.encode(data.toJson());

class SearchHistoryResponse {
  bool? success;
  String? message;
  List<SearchHistory>? data;

  SearchHistoryResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SearchHistoryResponse.fromJson(Map<String, dynamic> json) => SearchHistoryResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SearchHistory>.from(json["data"]!.map((x) => SearchHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SearchHistory {
  String? hashcode;
  String? group;
  String? search;
  int? total;
  int? hits;

  SearchHistory({
    this.hashcode,
    this.group,
    this.search,
    this.total,
    this.hits,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) => SearchHistory(
    hashcode: json["hashcode"],
    group: json["group"],
    search: json["search"],
    total: json["total"],
    hits: json["hits"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "group": group,
    "search": search,
    "total": total,
    "hits": hits,
  };
}
