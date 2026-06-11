import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/home/components/statistics/home_statistics_widget.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../utils/res/Resources.dart';
import 'categories/home_categories_widget.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.isFreelancerMode});

  final bool isFreelancerMode;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 6),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.colorPrimary,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(1000),
                    child: PrimaryNetworkImage(
                      url:
                          controller.profileData.value?.image ??
                          Prefs.getAvatar,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),

              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text:
                          " Hello ${controller.profileData.value?.firstName ?? Prefs.getFName} 👋 ",
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      textColor: context.resources.color.colorBlack,
                    ),
                    SizedBox(height: 6),
                    Obx(
                      () => UserTypeTabBar(
                        isFreelancer: controller.isFreelancerMode.value,
                        onSelect: (isFreelancer) {
                          controller.toggleUserMode(isFreelancer);
                        },
                      ),
                    ),
                    // // Verification Status
                    // if ((controller.profileData.value?.idVerified ?? 0) == 0)
                    //   GestureDetector(
                    //     onDoubleTap: () {
                    //       Get.toNamed(RouteConstant.uploadDocumentsScreen);
                    //     },
                    //     child: Container(
                    //       margin: EdgeInsets.only(top: 4),
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: 6,
                    //         vertical: 2,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: context.resources.color.colorWhite
                    //             .withOpacity(.2),
                    //         borderRadius: BorderRadius.circular(4),
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(
                    //             Icons.warning_amber_rounded,
                    //             color: context.resources.color.colorWhite,
                    //             size: 10,
                    //           ),
                    //           SizedBox(width: 4),
                    //           PrimaryText(
                    //             text: context.resources.strings.notVerified,
                    //             fontSize: 9,
                    //             fontWeight: FontWeight.w600,
                    //             textColor: context.resources.color.colorWhite,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),

              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteConstant.notificationsScreen);
                },
                child: Obx(() {
                  final count = controller.notificationsCount.value;
                  return Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.resources.color.colorGrey25,
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    children: [
                      Image.asset(AppIcons.notification, width: 24),
                      if (count > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Center(
                              child: PrimaryText(
                                text: count > 99 ? '99+' : count.toString(),
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                textColor: context.resources.color.colorWhite,
                              ),
                            ),
                          ),
                        ),
                    ],
                    ),
                  );
                }),
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteConstant.chatScreen);
                },
                child: Obx(() {
                  final count = controller.totalUnreadCount.value;
                  return Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.resources.color.colorGrey25,
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(AppIcons.message, width: 24),
                        if (count > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Center(
                                child: PrimaryText(
                                  text: count > 99 ? '99+' : count.toString(),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  textColor: context.resources.color.colorWhite,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),


          if(isFreelancerMode)
          HomeStatisticsWidget(),

          HomeCategoriesWidget(isFreelancerMode: isFreelancerMode),

        ],
      ),
    );
  }
}

class UserTypeTabBar extends StatelessWidget {
  const UserTypeTabBar({
    super.key,
    required this.isFreelancer,
    required this.onSelect,
  });

  final bool isFreelancer;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: context.resources.color.colorBlueL,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              onSelect(true);
            },
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isFreelancer
                    ? context.resources.color.colorWhite
                    : Colors.transparent,
                border: isFreelancer
                    ? Border.all(
                        width: 1,
                        color: context.resources.color.colorPrimary,
                      )
                    : null,
              ),
              child: Center(
                child: PrimaryText(
                  text: Resources.of(context).strings.freelancer,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  textColor: isFreelancer
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorGrey27,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              onSelect(false);
            },
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: !isFreelancer
                    ? context.resources.color.colorWhite
                    : Colors.transparent,
                border: !isFreelancer
                    ? Border.all(
                        width: 1,
                        color: context.resources.color.colorPrimary,
                      )
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: PrimaryText(
                  text: Resources.of(context).strings.employer,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  textColor: !isFreelancer
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorGrey27,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
