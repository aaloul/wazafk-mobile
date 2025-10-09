import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../../components/primary_switch.dart';

class ItemMyPackage extends StatelessWidget {
  const ItemMyPackage({
    super.key,
    required this.package,
    required this.onToggleStatus,
  });

  final Package package;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HexColor("#D5ECEF"),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor("#00AEC81A"), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: "${package.title}",
                  textColor: context.resources.color.colorPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
                PrimaryText(
                  text: "${package.services?.length ?? 0} Services",
                  textColor: context.resources.color.colorGrey8,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ],
            ),
          ),

          PrimaryText(
            text: "\$ ${package.totalPrice}",
            textColor: context.resources.color.colorPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),

          Obx(
            () => PrimarySwitch(
              scale: .7,
              checked: package.checked.value,
              thumbColorActive: context.resources.color.colorWhite,
              thumbColorNotActive: context.resources.color.colorWhite,
              trackColor: context.resources.color.colorGrey8,
              activeTrackColor: context.resources.color.colorPrimary,
              activeColor: context.resources.color.colorPrimary,
              onChange: (value) {
                onToggleStatus();
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Navigate to edit package screen when available
              // Get.toNamed(
              //   RouteConstant.addPackageScreen,
              //   arguments: package,
              // );
            },
            child: Image.asset(
              AppIcons.edit,
              width: 20,
              color: context.resources.color.colorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
