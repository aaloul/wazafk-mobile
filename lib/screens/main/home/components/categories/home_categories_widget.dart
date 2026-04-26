import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../skeletons/home_category_skeleton.dart';
import 'home_category_item.dart';

class HomeCategoriesWidget extends StatelessWidget {
  const HomeCategoriesWidget({super.key, required this.isFreelancerMode});

  final bool isFreelancerMode;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      children: [

        if(!isFreelancerMode)
        SizedBox(height: 20),
        Obx(() {
          final isLoading = isFreelancerMode
              ? controller.isLoadingJobCategories.value
              : controller.isLoadingCategories.value;
          final list = isFreelancerMode
              ? controller.jobCategories
              : controller.categories;

          if (isLoading && list.isEmpty) {
            return SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemBuilder: (context, index) => HomeCategorySkeleton(),
              ),
            );
          }

          if (list.isEmpty) {
            return SizedBox(
              height: 100,
              child: Center(child: Text(Resources
                  .of(context)
                  .strings
                  .noCategoriesAvailable)),
            );
          }

          return SizedBox(
            height: 102,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = list[index];
                return HomeCategoryItem(category: category);
              },
            ),
          );
        }),
      ],
    );
  }
}
