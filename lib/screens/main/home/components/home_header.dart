import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/search_widget.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../components/primary_switch.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      width: double.infinity,
      color: context.resources.color.colorPrimary,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Obx(() =>
                  ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(1000),
                child: PrimaryNetworkImage(
                  url: controller.profileData.value?.image ?? Prefs.getAvatar,
                  width: 40,
                  height: 40,
                ),
                  )),
              SizedBox(width: 10),

              Expanded(
                child: Obx(() =>
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: "${controller.profileData.value?.firstName ??
                          Prefs.getFName} ${controller.profileData.value
                          ?.lastName ?? Prefs.getLName}",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: context.resources.color.colorGrey6,
                    ),
                    PrimaryText(
                      text: controller.profileData.value?.title?.toString() ??
                          Prefs.getProfileTitle,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorWhite,
                    ),
                  ],
                    )),
              ),

              Obx(() =>
                  PrimarySwitch(
                    scale: .7,
                    checked: controller.isFreelancerMode.value,
                    onChange: (bool value) {
                      controller.toggleUserMode(value);
                    },
                  )),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteConstant.notificationsScreen);
                },
                child: Image.asset(AppIcons.notification, width: 24),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteConstant.chatScreen);
                },
                child: Image.asset(AppIcons.message, width: 24),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteConstant.searchScreen);
                  },
                  child: AbsorbPointer(
                    child: SearchWidget(
                      enabled: false,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: context.resources.color.colorWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Image.asset(AppIcons.filter, width: 20)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
