import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class TopLevelTabBar extends StatelessWidget {
  const TopLevelTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final String selectedTab;
  final Function(String) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(color: context.resources.color.colorWhite),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => onTabSelected(Resources.of(context).strings.chatConversations),
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: selectedTab == Resources.of(context).strings.chatConversations
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorWhite,
                ),
                child: Center(
                  child: PrimaryText(
                    text: Resources.of(context).strings.chatConversations,
                    fontWeight: FontWeight.w500,
                    textColor: selectedTab == Resources.of(context).strings.chatConversations
                        ? context.resources.color.colorWhite
                        : context.resources.color.colorGrey3,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => onTabSelected(Resources.of(context).strings.supportConversations),
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: selectedTab == Resources.of(context).strings.supportConversations
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorWhite,
                ),
                child: Center(
                  child: PrimaryText(
                    text: Resources.of(context).strings.supportConversations,
                    fontWeight: FontWeight.w500,
                    textColor: selectedTab == Resources.of(context).strings.supportConversations
                        ? context.resources.color.colorWhite
                        : context.resources.color.colorGrey3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
