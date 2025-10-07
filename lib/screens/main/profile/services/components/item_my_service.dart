import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../../components/primary_switch.dart';

class ItemMyService extends StatelessWidget {
  const ItemMyService({
    super.key,
    required this.service,
    required this.onToggleStatus,
  });

  final Service service;
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
                  text: "${service.title}",
                  textColor: context.resources.color.colorPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
                PrimaryText(
                  text: "${service.categoryName}",
                  textColor: context.resources.color.colorGrey8,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ],
            ),
          ),

          PrimaryText(
            text: "\$ ${service.unitPrice}/Hour",
            textColor: context.resources.color.colorPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),

          Obx(
            () => PrimarySwitch(
              scale: .7,
              checked: service.checked.value,
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
              Get.toNamed(
                RouteConstant.addServiceScreen,
                arguments: service,
              );
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
