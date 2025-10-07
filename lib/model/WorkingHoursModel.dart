class WorkingHoursDay {
  final String day;
  bool isEnabled;
  String startTime;
  String endTime;

  WorkingHoursDay({
    required this.day,
    this.isEnabled = true,
    this.startTime = '09:00',
    this.endTime = '17:00',
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'enabled': isEnabled,
    'start_time': startTime,
    'end_time': endTime,
  };
}
