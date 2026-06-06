import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import 'components/notification_sub_tabs_widget.dart';
import 'components/notification_tabs_widget.dart';
import 'components/notifications_list_widget.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: context.resources.color.colorWhite,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: RotatedBox(
                        quarterTurns: Utils().isRTL() ? 2 : 0,
                        child: Image.asset(AppIcons.back3, width: 40),
                      ),
                    ),
                  ),
                  PrimaryText(
                    text: Resources.of(context).strings.notifications,
                    textColor: context.resources.color.colorBlack4,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              final categories = controller.categories;
              final selectedIndex =
                  categories.indexOf(controller.selectedCategory.value);
              return NotificationTabsWidget(
                labels: categories
                    .map((c) => controller.categoryLabel(context, c))
                    .toList(),
                selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
                onSelect: (index) =>
                    controller.changeCategory(categories[index]),
                margin: 16,
              );
            }),
            SizedBox(height: 12),
            Divider(height: 1, color: context.resources.color.colorGrey4),
            Obx(() {
              final subs = controller
                  .subCategoriesFor(controller.selectedCategory.value);
              if (subs.isEmpty) return const SizedBox.shrink();
              final selectedSub = controller.selectedSubCategory.value;
              final selectedSubIndex =
                  selectedSub == null ? -1 : subs.indexOf(selectedSub);
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: NotificationSubTabsWidget(
                  labels: subs
                      .map((s) => controller.subCategoryLabel(context, s))
                      .toList(),
                  selectedIndex: selectedSubIndex,
                  onSelect: (index) {
                    controller.changeSubCategory(
                      index == -1 ? null : subs[index],
                    );
                  },
                ),
              );
            }),
            Expanded(child: NotificationsListWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
