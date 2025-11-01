import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class HomeCategoryItem extends StatelessWidget {
  const HomeCategoryItem({super.key, required this.category, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  void _handleTap() {
    if (onTap != null) {
      onTap!();
    } else {
      // Default behavior: check if category has subcategories
      if (category.hasSubCategories == true) {
        Get.toNamed(
          RouteConstant.subcategoriesScreen,
          arguments: category,
        );
      } else {
        Get.toNamed(
          RouteConstant.searchScreen,
          arguments: category,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
      width: 75,
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: .5,
                color: context.resources.color.colorBlue,
              ),
            ),
            child: PrimaryNetworkImage(
              url: category.icon.toString(),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SizedBox(height: 5),

          PrimaryText(
            text: category.name.toString(),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      ),
    );
  }
}
