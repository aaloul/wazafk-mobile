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

              Expanded(
                child: Obx(
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
              ),

              SizedBox(width: 8),

              Obx(() {
                final isVerified =
                    controller.profileData.value?.idVerified == 1;
                return _VerifiedPill(
                  isVerified: isVerified,
                  onTap: isVerified
                      ? null
                      : () => Get.toNamed(
                          RouteConstant.uploadDocumentsScreen),
                );
              }),
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
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => Get.toNamed(
                                  RouteConstant.topUpScreen),
                              child: Column(
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
                            ),

                            SizedBox(width: 16,),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => Get.toNamed(
                                  RouteConstant.withdrawScreen),
                              child: Column(
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
                            ),

                            Spacer(),

                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => Get.toNamed(
                                  RouteConstant.walletHistoryScreen),
                              child: Column(
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
        ],
      ),
    );
  }
}

/// Compact verification pill placed top-right of the profile header per
/// Figma p117 — light-green for Verified (with a check-circle icon),
/// light-red for Not Verified (with an info-circle icon). The "Not Verified"
/// variant is tappable and routes to the upload-documents flow.
class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill({required this.isVerified, required this.onTap});

  final bool isVerified;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final bg = isVerified
        ? colors.colorGreen5
        : const Color(0xFFFFE5E5);
    final fg = isVerified ? colors.colorGreen6 : colors.colorRed2;
    final label =
        isVerified ? strings.verifiedPill : strings.notVerified;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryText(
              text: label,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              textColor: fg,
            ),
            const SizedBox(width: 5),
            Image.asset(
              AppIcons.checkCircle,
              width: 13,
              color: fg,
            ),
          ],
        ),
      ),
    );
  }
}
