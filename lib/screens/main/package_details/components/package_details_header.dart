import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../components/progress_bar.dart';
import '../../../../utils/Prefs.dart';
import '../../../../utils/utils.dart';
import '../package_details_controller.dart';

class PackageDetailsHeader extends StatelessWidget {
  const PackageDetailsHeader({super.key});

  String _getCategoryText(Package package) {
    if (package.services == null || package.services!.isEmpty) return '';
    final firstService = package.services!.first;
    if (firstService.parentCategoryName != null) {
      return '${firstService.parentCategoryName} / ${firstService.categoryName}';
    }
    return firstService.categoryName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PackageDetailsController>();
    final package = controller.package.value;

    return Container(
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: Utils().isRTL() ? 2 : 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(AppIcons.back3, width: 38),
                  ),
                ),
                const Spacer(),
                if (package?.memberHashcode != Prefs.getId)
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isFavoriteLoading.value
                          ? null
                          : controller.toggleFavorite,
                      child: controller.isFavoriteLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: ProgressBar(),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.resources.color.colorGrey15,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  controller.isFavorite.value
                                      ? AppIcons.banomarkOn
                                      : AppIcons.banomark,
                                  width: 18,
                                  color: context.resources.color.colorPrimary,
                                ),
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryText(
              text: package?.title ?? '',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textColor: context.resources.color.colorBlack,
            ),
          ),
          if (package != null && _getCategoryText(package).isNotEmpty) ...[
            const SizedBox(height: 2),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryText(
                text: _getCategoryText(package),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: context.resources.color.colorGrey,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
