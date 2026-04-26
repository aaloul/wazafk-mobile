import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../../model/SettingsModel.dart';
import '../../profile_controller.dart';

class SettingsGroupWidget extends StatelessWidget {
  const SettingsGroupWidget({super.key, required this.settingsGroup});

  final SettingsGroup settingsGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.resources.color.colorGrey25,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (settingsGroup.title.isNotEmpty)
            PrimaryText(
              text: settingsGroup.title,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              textColor: context.resources.color.colorBlack2,
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
        width: double.infinity,
        decoration: BoxDecoration(color: context.resources.color.colorWhite),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  settingsModel.icon,
                  height: 24,
                  width: 24,
                  color: context.resources.color.colorGrey29,
                ),
                Container(
                  width: 1,
                  height: 20,
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  color: context.resources.color.colorGrey25,
                ),
                Expanded(
                  child: PrimaryText(
                    text: settingsModel.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: context.resources.color.colorGrey26,
                  ),
                ),
                RotatedBox(
                  quarterTurns: Utils().isRTL() ? 2 : 0,
                  child: Image.asset(
                    AppIcons.arrowRight2,
                    width: 18,
                    color: context.resources.color.colorGrey26  ,
                  ),
                ),
              ],
            ),

            if(index != totalLength -1)
            Container(
              width: double.infinity,
              height: 1,
              margin: EdgeInsets.symmetric(vertical: 12),
              color: context.resources.color.colorGrey25,
            ),
          ],
        ),
      ),
    );
  }
}
