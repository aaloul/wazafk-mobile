// To parse this JSON data, do
//
//     final searchSuggestionResponse = searchSuggestionResponseFromJson(jsonString);

import 'dart:convert';

SearchSuggestionResponse searchSuggestionResponseFromJson(String str) => SearchSuggestionResponse.fromJson(json.decode(str));

String searchSuggestionResponseToJson(SearchSuggestionResponse data) => json.encode(data.toJson());

class SearchSuggestionResponse {
  bool? success;
  String? message;
  List<SearchSuggestion>? data;

  SearchSuggestionResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SearchSuggestionResponse.fromJson(Map<String, dynamic> json) => SearchSuggestionResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SearchSuggestion>.from(json["data"]!.map((x) => SearchSuggestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SearchSuggestion {
  String? search;
  int? totalHits;

  SearchSuggestion({
    this.search,
    this.totalHits,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) => SearchSuggestion(
    search: json["search"],
    totalHits: json["total_hits"],
  );

  Map<String, dynamic> toJson() => {
    "search": search,
    "total_hits": totalHits,
  };
}
