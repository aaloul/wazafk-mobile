// To parse this JSON data, do
//
//     final scheduleTasksResponse = scheduleTasksResponseFromJson(jsonString);

import 'dart:convert';

ScheduleTasksResponse scheduleTasksResponseFromJson(String str) =>
    ScheduleTasksResponse.fromJson(json.decode(str));

String scheduleTasksResponseToJson(ScheduleTasksResponse data) =>
    json.encode(data.toJson());

class ScheduleTasksResponse {
  bool? success;
  String? message;
  List<ScheduleTask>? data;

  ScheduleTasksResponse({this.success, this.message, this.data});

  factory ScheduleTasksResponse.fromJson(Map<String, dynamic> json) =>
      ScheduleTasksResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ScheduleTask>.from(
                json["data"]!.map((x) => ScheduleTask.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ScheduleTask {
  String? hashcode;
  String? type;
  String? title;
  String? description;
  DateTime? date;
  String? startTime;
  String? endTime;
  int? status;

  ScheduleTask({
    this.hashcode,
    this.type,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
  });

  factory ScheduleTask.fromJson(Map<String, dynamic> json) => ScheduleTask(
    hashcode: json["hashcode"],
    type: json["type"],
    title: json["title"],
    description: json["description"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "hashcode": hashcode,
    "type": type,
    "title": title,
    "description": description,
    "date":
        "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "status": status,
  };
}
