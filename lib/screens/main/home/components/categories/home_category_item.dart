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
          SizedBox(
            width: 75,
            height: 75,
            child: Card(
              color: Colors.white,
              elevation: 12,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: context.resources.color.colorGrey15,
                  width: 1,
                ),
              ),
              child: SizedBox(
                width: 75,
                height: 75,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: PrimaryNetworkImage(
                    url: category.icon.toString(),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2),

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
