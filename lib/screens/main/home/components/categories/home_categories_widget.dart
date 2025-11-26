import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../skeletons/home_category_skeleton.dart';
import 'home_category_item.dart';

class HomeCategoriesWidget extends StatelessWidget {
  const HomeCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryText(
                  text: "Services",
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.onViewAllCategories();
                },
                child: PrimaryText(
                  text: "View All",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorGrey14,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.isLoadingCategories.value &&
                controller.categories.isEmpty) {
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

            if (controller.categories.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(child: Text('No categories available')),
              );
            }

            return SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return HomeCategoryItem(category: category);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
