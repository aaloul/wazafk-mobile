import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../../components/primary_switch.dart';
import '../../../../../components/progress_bar.dart';

class ItemMyPackage extends StatefulWidget {
  const ItemMyPackage({
    super.key,
    required this.package,
    required this.onToggleStatus,
  });

  final Package package;
  final Future<void> Function() onToggleStatus;

  @override
  State<ItemMyPackage> createState() => _ItemMyPackageState();
}

class _ItemMyPackageState extends State<ItemMyPackage> {
  bool isTogglingStatus = false;

  Future<void> handleToggleStatus() async {
    setState(() {
      isTogglingStatus = true;
    });

    try {
      await widget.onToggleStatus();
    } finally {
      if (mounted) {
        setState(() {
          isTogglingStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstant.packageDetailsScreen, arguments: widget.package);
      },
      child: Container(
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
                  text: "${widget.package.title}",
                  textColor: context.resources.color.colorPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
                PrimaryText(
                  text: "${widget.package.services?.length ?? 0} Services",
                  textColor: context.resources.color.colorGrey8,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ],
            ),
          ),

          PrimaryText(
            text: "\$ ${widget.package.totalPrice}",
            textColor: context.resources.color.colorPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),

          isTogglingStatus
              ? SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: ProgressBar(),
                    ),
                  ),
                )
              : Obx(
                  () => PrimarySwitch(
                    scale: .7,
                    checked: widget.package.checked.value,
                    thumbColorActive: context.resources.color.colorWhite,
                    thumbColorNotActive: context.resources.color.colorWhite,
                    trackColor: context.resources.color.colorGrey8,
                    activeTrackColor: context.resources.color.colorPrimary,
                    activeColor: context.resources.color.colorPrimary,
                    onChange: (value) {
                      handleToggleStatus();
                    },
                  ),
                ),
          GestureDetector(
            onTap: () async {
              final result = await Get.toNamed(
                RouteConstant.addPackageScreen,
                arguments: widget.package,
              );
              // Refresh packages list if edited
              if (result == true) {
                // Trigger a refresh by calling the controller
                // The FocusDetector in PacksScreen will handle this
              }
            },
            child: Image.asset(
              AppIcons.edit,
              width: 20,
              color: context.resources.color.colorPrimary,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
