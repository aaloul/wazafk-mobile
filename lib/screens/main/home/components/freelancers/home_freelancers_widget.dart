import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'home_freelancer_item.dart';

class HomeFreelancersWidget extends StatelessWidget {
  const HomeFreelancersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoadingEmployerHome.value) {
        return SizedBox.shrink();
      }

      if (controller.freelancers.isEmpty) {
        return SizedBox.shrink();
      }

      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryText(
                    text: 'Freelancers',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorBlack,
                  ),
                  PrimaryText(
                    text: 'View All',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey14,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: controller.freelancers
                    .map(
                      (freelancer) =>
                          HomeFreelancerItem(freelancer: freelancer.member!),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
