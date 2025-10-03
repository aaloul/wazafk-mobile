import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/search_widget.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../components/primary_switch.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.resources.color.colorPrimary,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(1000),
                child: PrimaryNetworkImage(
                  url: Prefs.getAvatar,
                  width: 40,
                  height: 40,
                ),
              ),
              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: "${Prefs.getFName} ${Prefs.getLName}",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: context.resources.color.colorGrey6,
                    ),
                    PrimaryText(
                      text: "UX/UI Designer",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorWhite,
                    ),
                  ],
                ),
              ),

              PrimarySwitch(scale: .7, checked: true, onChange: (b) {}),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteConstant.profileNotificationsScreen);
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
              Expanded(child: SearchWidget()),
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
