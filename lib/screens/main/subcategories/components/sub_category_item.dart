import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class SubCategoryItem extends StatelessWidget {
  const SubCategoryItem({super.key, required this.category, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  void _handleTap() {
    if (onTap != null) {
      onTap!();
    } else {
      // Default behavior: check if category has subcategories
      if (category.hasSubCategories == true) {
        Get.toNamed(RouteConstant.subcategoriesScreen, arguments: category);
      } else {
        Get.toNamed(RouteConstant.searchScreen, arguments: category);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        color: context.resources.color.colorWhite,
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: PrimaryNetworkImage(
                    url: category.icon.toString(),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                SizedBox(width: 8),

                PrimaryText(
                  text: category.name.toString(),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  maxLines: 2,
                  textColor: context.resources.color.colorGrey,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
