import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({super.key, required this.category, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  void _handleTap() {
    if (onTap != null) {
      onTap!();
    } else if (category.hasSubCategories == true) {
      Get.toNamed(
        RouteConstant.subcategoriesScreen,
        arguments: category,
        preventDuplicates: false,
      );
    } else {
      Get.toNamed(RouteConstant.searchScreen, arguments: category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.resources.color.colorPrimary,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: PrimaryNetworkImage(
                url: category.icon.toString(),
                width: 36,
                height: 36,
              ),
            ),
            const SizedBox(height: 10),
            PrimaryText(
              text: category.name ?? '',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              maxLines: 2,
              textAlign: TextAlign.center,
              textColor: context.resources.color.colorBlack,
              height: 1.2,
            ),
          ],
        ),
      ),
    );
  }
}
