import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../skeletons/home_engagement_skeleton.dart';
import 'home_engagement_item.dart';

class HomeEngagementsWidget extends StatelessWidget {
  const HomeEngagementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoadingEngagements.value &&
          controller.engagements.isEmpty) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PrimaryText(
                  text: context.resources.strings.upcomingTasksAndProjects,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlack,
                ),
              ),
              SizedBox(height: 12),
              CarouselSlider.builder(
                itemCount: 2,
                options: CarouselOptions(
                  height: 193,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.80,
                  enableInfiniteScroll: false,
                ),
                itemBuilder: (context, index, realIndex) {
                  return HomeEngagementSkeleton();
                },
              ),
            ],
          ),
        );
      }

      if (controller.engagements.isEmpty) {
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
                    text: context.resources.strings.upcomingTasksAndProjects,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorBlack,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteConstant.allEngagementsScreen);
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
            CarouselSlider.builder(
              itemCount: controller.engagements.length,
              options: CarouselOptions(
                height: 193,
                autoPlay: controller.engagements.length > 1,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                enlargeCenterPage: false,
                viewportFraction: 0.80,
                enableInfiniteScroll: controller.engagements.length > 1,
              ),
              itemBuilder: (context, index, realIndex) {
                final engagement = controller.engagements[index];
                return HomeEngagementItem(engagement: engagement);
              },
            ),
          ],
        ),
      );
    });
  }
}
