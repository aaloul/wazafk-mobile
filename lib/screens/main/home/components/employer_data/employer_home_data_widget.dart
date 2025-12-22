import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../skeletons/home_freelancer_skeleton.dart';
import 'home_freelancer_item.dart';
import 'home_package_item.dart';
import 'home_service_item.dart';

class EmployerHomeDataWidget extends StatelessWidget {
  const EmployerHomeDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoadingEmployerHome.value &&
          controller.employerData.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryText(
                text: context.resources.strings.freelancer,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: context.resources.color.colorBlack,
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) => HomeFreelancerSkeleton(),
            ),
          ],
        );
      }

      if (controller.employerData.isEmpty) {
        return SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryText(
                  text: context.resources.strings.freelancer,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlack,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteConstant.allEmployerDataScreen);
                  },
                  child: PrimaryText(
                    text: context.resources.strings.viewAll,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.employerData.length,
            itemBuilder: (context, index) {
              final data = controller.employerData[index];

              // Render different widgets based on entity type
              if (data.entityType == 'MEMBER' && data.member != null) {
                return HomeFreelancerItem(
                  freelancer: data.member!,
                  onFavoriteToggle: controller.toggleMemberFavorite,
                );
              } else if (data.entityType == 'SERVICE' && data.service != null) {
                return HomeServiceItem(
                  service: data.service!,
                  onFavoriteToggle: controller.toggleServiceFavorite,
                );
              } else if (data.entityType == 'PACKAGE' && data.package != null) {
                return HomePackageItem(
                  package: data.package!,
                  onFavoriteToggle: controller.togglePackageFavorite,
                );
              }
              // Return empty container for unknown types
              return SizedBox.shrink();
            },
          ),
        ],
      );
    });
  }
}
