import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class NotificationTabsWidget extends StatelessWidget {
  const NotificationTabsWidget({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
    this.margin,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final double? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.resources.color.colorBlueL,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected
                      ? context.resources.color.colorWhite
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: context.resources.color.colorPrimary,
                          width: 1,
                        )
                      : null,
                ),
                child: Center(
                  child: PrimaryText(
                    textAlign: TextAlign.center,
                    text: labels[index],
                    textColor: isSelected
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorGrey27,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
