import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Multi-select subcategory chips shown under the home category bar once a
/// category is selected (design p35). Toggling a chip reloads the home feed.
class HomeSubcategoriesWidget extends StatelessWidget {
  const HomeSubcategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.selectedCategory.value == null) {
        return const SizedBox.shrink();
      }

      final isLoading = controller.isLoadingSubcategories.value;
      final subs = controller.subcategories;

      if (isLoading && subs.isEmpty) {
        return _wrap(_LoadingChips());
      }

      if (subs.isEmpty) {
        return const SizedBox.shrink();
      }

      // Read the selection synchronously here so the Obx registers it as a
      // dependency — reads inside ListView.itemBuilder run too late to track.
      final selectedHashes = controller.selectedSubcategories
          .map((c) => c.hashcode)
          .toSet();

      return _wrap(
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: subs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final sub = subs[index];
              final selected = selectedHashes.contains(sub.hashcode);
              return _SubcategoryChip(
                label: sub.name ?? '',
                selected: selected,
                onTap: () => controller.toggleSubcategory(sub),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _wrap(Widget child) =>
      Padding(padding: const EdgeInsets.only(top: 14), child: child);
}

class _SubcategoryChip extends StatelessWidget {
  const _SubcategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.resources.color.colorPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? context.resources.color.colorPrimaryLight
              : context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? primary : context.resources.color.colorGrey25,
            width: selected ? 1 : 1,
          ),
        ),
        child: PrimaryText(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          textColor: selected ? primary : context.resources.color.colorBlack,
        ),
      ),
    );
  }
}

class _LoadingChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
