import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class NotificationTabsWidget extends StatelessWidget {
  const NotificationTabsWidget({
    super.key,
    required this.tabs,
    required this.onSelect,
    this.margin,
    required this.selectedTab,
  });

  final List<String> tabs;
  final Function onSelect;
  final String selectedTab;
  final double? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.resources.color.colorBlueL,
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(tab),
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
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xA64EA9EE),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: Offset.zero,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: PrimaryText(
                    textAlign: TextAlign.center,
                    text: tab,
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
        }).toList(),
      ),
    );
  }
}
