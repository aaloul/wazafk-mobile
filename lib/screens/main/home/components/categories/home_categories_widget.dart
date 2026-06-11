import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../skeletons/home_category_skeleton.dart';
import 'home_category_item.dart';

class HomeCategoriesWidget extends StatelessWidget {
  const HomeCategoriesWidget({super.key, required this.isFreelancerMode});

  final bool isFreelancerMode;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final strings = Resources.of(context).strings;

    return Column(
      children: [
        if (!isFreelancerMode) const SizedBox(height: 20),
        Obx(() {
          final isLoading = isFreelancerMode
              ? controller.isLoadingJobCategories.value
              : controller.isLoadingCategories.value;
          final list = isFreelancerMode
              ? controller.jobCategories
              : controller.categories;

          if (isLoading && list.isEmpty) {
            return SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) => const HomeCategorySkeleton(),
              ),
            );
          }

          if (list.isEmpty) {
            return SizedBox(
              height: 100,
              child: Center(child: Text(strings.noCategoriesAvailable)),
            );
          }

          final selectedHash = controller.selectedCategory.value?.hashcode;

          // [All] + categories + [view all (+)]
          final itemCount = list.length + 2;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // "View all" link above the category row (design p35).
              GestureDetector(
                onTap: controller.onViewAllCategories,
                child: PrimaryText(
                  text: strings.viewAll,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  isUnderLined: true,
                  textColor: context.resources.color.colorPrimary,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: itemCount,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return HomeCategoryItem(
                        label: strings.all,
                        iconAsset: AppIcons.categoryAll,
                        isSelected: selectedHash == null,
                        onTap: () => controller.onCategorySelected(null),
                      );
                    }
                    if (index == itemCount - 1) {
                      return _ViewAllItem(
                          onTap: controller.onViewAllCategories);
                    }

                    final category = list[index - 1];
                    return HomeCategoryItem(
                      label: category.name.toString(),
                      iconUrl: category.icon.toString(),
                      isSelected: selectedHash != null &&
                          selectedHash == category.hashcode,
                      onTap: () => controller.onCategorySelected(category),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

/// The trailing "+" card that opens the full categories screen (design p35).
class _ViewAllItem extends StatelessWidget {
  const _ViewAllItem({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: context.resources.color.colorBlueL,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    shape: BoxShape.circle,
                  ),
                  child: PrimaryText(
                    text: '+',
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
