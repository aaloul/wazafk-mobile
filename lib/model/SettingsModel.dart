class SettingsModel {
  late int id;
  late String title;
  late String icon;

  SettingsModel({required this.id, required this.title, required this.icon});
}

class SettingsGroup {
  late String title;
  List<SettingsModel> items = [];

  SettingsGroup({required this.title, required this.items});
}
