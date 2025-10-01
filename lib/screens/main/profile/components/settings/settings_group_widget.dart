import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../../model/SettingsModel.dart';
import '../../profile_controller.dart';

class SettingsGroupWidget extends StatelessWidget {
  const SettingsGroupWidget({super.key, required this.settingsGroup});

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
              textColor: context.resources.color.colorGrey3,
            ),
          if (settingsGroup.title.isNotEmpty) SizedBox(height: 14),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: settingsGroup.items.length,
            itemBuilder: (BuildContext context, int index) {
              return SettingItem(
                settingsModel: settingsGroup.items[index],
                onClick: (id) {
                  final controller = Get.find<ProfileController>();
                  controller.handleSettingsItemClick(id);
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

class SettingItem extends StatelessWidget {
  const SettingItem({
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
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 14),
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
            Image.asset(settingsModel.icon, height: 24, width: 24),
            Container(
              width: 2,
              height: 22,
              margin: EdgeInsets.symmetric(horizontal: 14),
              color: context.resources.color.colorGrey.withOpacity(.1),
            ),
            Expanded(
              child: PrimaryText(
                text: settingsModel.title,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: context.resources.color.colorGrey10,
              ),
            ),
            Image.asset(AppIcons.arrowRight2, width: 18),
          ],
        ),
      ),
    );
  }
}
