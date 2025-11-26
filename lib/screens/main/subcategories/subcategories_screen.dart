import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/skeletons/category_item_skeleton.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/search_widget.dart';
import 'components/sub_category_item.dart';
import 'subcategories_controller.dart';

class SubcategoriesScreen extends StatelessWidget {
  const SubcategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubcategoriesController(),
        tag: DateTime
            .timestamp()
            .millisecond
            .toString());


    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopHeader(
                hasBack: true,
                title: controller.parentCategory.value?.name ?? 'Subcategories',
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SearchWidget(
                hint: 'Search subcategories...',
                borderRadius: 0,
                onTextChangedWithDelay: (text) {
                  controller.searchSubcategories(text);
                },
                enabled: true,
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: 5,
                    itemBuilder: (context, index) => CategoryItemSkeleton(),
                  );
                }

                if (controller.subcategories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          controller.searchQuery.value.isEmpty
                              ? Icons.category_outlined
                              : Icons.search_off,
                          size: 80,
                          color: context.resources.color.colorGrey8,
                        ),
                        SizedBox(height: 16),
                        PrimaryText(
                          text: controller.searchQuery.value.isEmpty
                              ? 'No subcategories found'
                              : 'No results found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: context.resources.color.colorGrey8,
                        ),
                        if (controller.searchQuery.value.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: PrimaryText(
                              text: 'Try searching with different keywords',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorGrey,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = controller.subcategories[index];
                    return GestureDetector(
                      onTap: () {
                        controller.onSubcategoryTap(subcategory);
                      },
                      child: SubCategoryItem(category: subcategory),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
