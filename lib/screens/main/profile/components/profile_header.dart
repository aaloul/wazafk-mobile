import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_network_image.dart';
import '../../../../components/primary_text.dart';
import '../../../../utils/Prefs.dart';
import '../../../../utils/res/AppIcons.dart';
import '../../home/components/home_header.dart';
import '../../home/home_controller.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({super.key});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x994EA9EE), // rgba(78, 169, 238, 0.6)
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => SizedBox(
                  width: 47,
                  height: 47,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(1000),
                    child: PrimaryNetworkImage(
                      url:
                          controller.profileData.value?.image ??
                          Prefs.getAvatar,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text:
                          "${controller.profileData.value?.firstName ?? Prefs.getFName} ${controller.profileData.value?.lastName ?? Prefs.getLName}",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: context.resources.color.colorBlack,
                    ),

                    SizedBox(height: 4),

                    Obx(
                      () => UserTypeTabBar(
                        isFreelancer: controller.isFreelancerMode.value,
                        onSelect: (isFreelancer) {
                          controller.toggleUserMode(isFreelancer);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          SizedBox(
            height: 172,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(12),
                    child: Image.asset(AppIcons.profileBg, fit: BoxFit.cover),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: 'Your Balance',
                                    textColor:
                                        context.resources.color.colorSnowWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                  SizedBox(height: 2),
                                  PrimaryText(
                                    text: '\$${controller.walletBalance.value}',
                                    textColor:
                                        context.resources.color.colorWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ],
                              ),
                            ),

                            Image.asset(AppIcons.logoW, width: 70),
                          ],
                        ),

                        Container(
                          width: double.infinity,
                          height: 1,
                          color: context.resources.color.colorWhite.withAlpha(
                            30,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 14),
                        ),

                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(AppIcons.topUp, width: 38),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: 'Top Up',
                                  fontWeight: FontWeight.w600,
                                  textColor:
                                      context.resources.color.colorSnowWhite,
                                  fontSize: 12,
                                ),
                              ],
                            ),

                            SizedBox(width: 16,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(AppIcons.withdraw, width: 38),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: 'Withdraw',
                                  fontWeight: FontWeight.w600,
                                  textColor:
                                      context.resources.color.colorSnowWhite,
                                  fontSize: 12,
                                ),
                              ],
                            ),

                            Spacer(),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(AppIcons.history, width: 38),
                                SizedBox(height: 4),
                                PrimaryText(
                                  text: 'History',
                                  fontWeight: FontWeight.w600,
                                  textColor:
                                  context.resources.color.colorSnowWhite,
                                  fontSize: 12,
                                ),
                              ],
                            ),


                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                color: context.resources.color.colorPrimary.withOpacity(.30),
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
                        horizontal: 12,
                        vertical: 6,
                      ),
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


        ],
      ),
    );
  }
}
