import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class NotificationSubTabsWidget extends StatelessWidget {
  const NotificationSubTabsWidget({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  /// Selected index. -1 = no sub-tab selected (all under this category).
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final selected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(selected ? -1 : index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: context.resources.color.colorWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorGrey4,
                  width: 1,
                ),
              ),
              child: Center(
                child: PrimaryText(
                  text: labels[index],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: selected
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorBlack,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
