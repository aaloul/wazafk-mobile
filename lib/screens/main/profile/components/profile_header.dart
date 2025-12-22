import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_network_image.dart';
import '../../../../components/primary_text.dart';
import '../../../../utils/Prefs.dart';
import '../../../../utils/res/AppIcons.dart';
import '../../home/components/statistics/home_statistics_widget.dart';
import '../../home/home_controller.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({super.key});

  final controller = Get.find<HomeController>();


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.resources.color.colorPrimary,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Obx(() =>
                  Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    shape: BoxShape.circle
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(1000),
                  child: PrimaryNetworkImage(
                    url: controller.profileData.value?.image ?? Prefs.getAvatar,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              ),

              SizedBox(width: 12,),

              Expanded(
                child: Obx(() =>
                PrimaryText(
                  text: "${controller.profileData.value?.firstName ??
                      Prefs.getFName} ${controller.profileData.value
                      ?.lastName ?? Prefs.getLName}",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textColor: context.resources.color.colorWhite,),
                ),
              ),


              GestureDetector(onTap: () {},
                  child: Image.asset(AppIcons.profile, width: 20,
                    color: context.resources.color.colorWhite,)),

              Container(
                height: 24,
                width: 1,
                margin: EdgeInsets.symmetric(horizontal: 8),
                color: context.resources.color.colorWhite.withOpacity(.7),
              ),
              GestureDetector(onTap: () {},
                  child: Image.asset(AppIcons.file, width: 20,
                      color: context.resources.color.colorWhite)),
            ],
          ),

          // Verification Status
          Obx(() {
            final isVerified = controller.profileData.value?.idVerified == 1;
            if (isVerified) {
              return SizedBox.shrink();
            }

            return Container(
              margin: EdgeInsets.only(top: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.resources.color.colorWhite.withOpacity(.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: context.resources.color.colorWhite,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: PrimaryText(
                      text: context.resources.strings.notVerified,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorWhite,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteConstant.uploadDocumentsScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.resources.color.colorWhite,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: PrimaryText(
                        text: context.resources.strings.verifyNow,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: context.resources.color.colorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          Container(
            height: 1,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 16),
            color: context.resources.color.colorWhite.withOpacity(.25),
          ),

          Row(
            children: [
              Obx(() =>
                  StatisticsItem(
                    title: context.resources.strings.totalEarnings,
                    value: '\$${controller.totalEarnings.value}',
                textIcon: "\$",
                icon: "",
              ),
              ),
              SizedBox(width: 12),
              Obx(() =>
                  StatisticsItem(
                    title: context.resources.strings.wallet,
                    value: '\$${controller.walletBalance.value}',
                icon: AppIcons.wallet,
              ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
