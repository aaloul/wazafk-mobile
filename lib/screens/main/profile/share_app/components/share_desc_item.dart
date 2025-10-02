import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/primary_text.dart';
import '../../../../../model/SettingsModel.dart';

class ShareDescItem extends StatelessWidget {
  const ShareDescItem({
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
            Image.asset(settingsModel.icon, width: 55),
            Container(
              width: 2,
              height: 32,
              margin: EdgeInsets.symmetric(horizontal: 14),
              color: context.resources.color.colorGrey.withOpacity(.1),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: settingsModel.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    textColor: context.resources.color.colorGrey10,
                  ),

                  SizedBox(height: 4),

                  PrimaryText(
                    text: settingsModel.desc.toString(),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
