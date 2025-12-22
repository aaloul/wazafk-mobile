import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/skeletons/category_item_skeleton.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../components/search_widget.dart';
import '../subcategories/components/sub_category_item.dart';
import 'all_categories_controller.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllCategoriesController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: Resources
                .of(context)
                .strings
                .allCategories),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SearchWidget(
                hint: Resources
                    .of(context)
                    .strings
                    .searchCategories,
                borderRadius: 0,
                onTextChangedWithDelay: (text) {
                  controller.searchCategories(text);
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

                if (controller.categories.isEmpty) {
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
                              ? Resources
                              .of(context)
                              .strings
                              .noCategoriesFound
                              : Resources
                              .of(context)
                              .strings
                              .noResultsFound,
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
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return SubCategoryItem(
                      category: category,
                      onTap: () {
                        controller.onCategoryTap(category);
                      },
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
