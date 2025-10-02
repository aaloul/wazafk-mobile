import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_switch.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/profile/notification_settings/notification_settings_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../model/SettingsModel.dart';

class NotificationSettingsGroup extends StatelessWidget {
  const NotificationSettingsGroup({super.key, required this.settingsGroup});

  final SettingsGroup settingsGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          if (settingsGroup.title.isNotEmpty)
            PrimaryText(
              text: settingsGroup.title,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              textColor: context.resources.color.colorGrey,
            ),
          if (settingsGroup.title.isNotEmpty) SizedBox(height: 14),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: settingsGroup.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = settingsGroup.items[index];
              return NotificationSettingItem(
                settingsModel: item,
                onClick: (value) {
                  final controller = Get.find<NotificationSettingsController>();
                  controller.handleSettingsItemClick(value, item);
                },
                index: index,
                totalLength: settingsGroup.items.length,
              );
            },
          ),
        ],
      ),
    );
  }
}

class NotificationSettingItem extends StatelessWidget {
  const NotificationSettingItem({
    super.key,
    required this.settingsModel,
    required this.onClick,
    required this.index,
    required this.totalLength,
  });

  final SettingsModel settingsModel;
  final Function onClick;
  final int index;
  final int totalLength;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(settingsModel.id),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.only(
            bottomLeft: index == totalLength - 1
                ? Radius.circular(10)
                : Radius.circular(0),
            bottomRight: index == totalLength - 1
                ? Radius.circular(10)
                : Radius.circular(0),
            topRight: index == 0 ? Radius.circular(10) : Radius.circular(0),
            topLeft: index == 0 ? Radius.circular(10) : Radius.circular(0),
          ),
          border: Border.all(color: context.resources.color.colorGrey9),
        ),
        child: Row(
          children: [
            Expanded(
              child: PrimaryText(
                text: settingsModel.title,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                textColor: context.resources.color.colorGrey10,
              ),
            ),
            Obx(
              () => PrimarySwitch(
                checked: settingsModel.checked.value,
                thumbColorActive: context.resources.color.colorWhite,
                thumbColorNotActive: context.resources.color.colorWhite,
                trackColor: context.resources.color.colorGrey8,
                activeTrackColor: context.resources.color.colorPrimary,
                activeColor: context.resources.color.colorPrimary,
                onChange: onClick,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
