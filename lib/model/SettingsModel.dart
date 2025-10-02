import 'package:get/get.dart';

class SettingsModel {
  late int id;
  late String title;
  late String icon;
  late String? desc;

  var checked = true.obs;

  SettingsModel(
      {required this.id, required this.title, required this.icon, this.desc});
}

class SettingsGroup {
  late String title;
  List<SettingsModel> items = [];

  SettingsGroup({required this.title, required this.items});
}
