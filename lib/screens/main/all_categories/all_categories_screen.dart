import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../components/search_widget.dart';
import '../../../components/skeletons/category_item_skeleton.dart';
import '../subcategories/components/category_grid_item.dart';
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
            const SizedBox(height: 8),
            _CategoriesHeader(
              hint: Resources.of(context).strings.searchCategories,
              onTextChanged: controller.searchCategories,
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: context.resources.color.colorGrey4),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: 9,
                    itemBuilder: (_, __) => const CategoryItemSkeleton(),
                  );
                }

                if (controller.categories.isEmpty) {
                  return _EmptyState(
                    isSearching: controller.searchQuery.value.isNotEmpty,
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return CategoryGridItem(
                      category: category,
                      onTap: () => controller.onCategoryTap(category),
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

class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader({required this.hint, required this.onTextChanged});

  final String hint;
  final ValueChanged<String> onTextChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: RotatedBox(
              quarterTurns: Utils().isRTL() ? 2 : 0,
              child: Image.asset(AppIcons.back3, width: 40),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SearchWidget(
              hint: hint,
              borderRadius: 12,
              height: 40,
              onTextChangedWithDelay: (text) => onTextChanged(text),
              enabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isSearching});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final strings = Resources.of(context).strings;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.category_outlined,
            size: 80,
            color: context.resources.color.colorGrey8,
          ),
          const SizedBox(height: 16),
          PrimaryText(
            text:
                isSearching ? strings.noResultsFound : strings.noCategoriesFound,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: context.resources.color.colorGrey8,
          ),
          if (isSearching) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: PrimaryText(
                text: strings.trySearchingWithDifferentKeywords,
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
}
