import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class SupportTabBar extends StatelessWidget {
  const SupportTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final String selectedTab;
  final Function(String) onTabSelected;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 42,
      margin: EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => onTabSelected(Resources.of(context).strings.support),
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(46),
                  color: selectedTab == Resources.of(context).strings.support
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorWhite,
                ),
                child: Center(
                  child: PrimaryText(
                    text: Resources.of(context).strings.support,
                    fontWeight: FontWeight.w500,
                    textColor: selectedTab == Resources.of(context).strings.support
                        ? context.resources.color.colorWhite
                        : context.resources.color.colorGrey3,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8,),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => onTabSelected(Resources.of(context).strings.dispute),
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(46),
                  color: selectedTab == Resources.of(context).strings.dispute
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorWhite,
                ),
                child: Center(
                  child: PrimaryText(
                    text: Resources.of(context).strings.dispute,
                    fontWeight: FontWeight.w500,
                    textColor: selectedTab == Resources.of(context).strings.dispute
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
