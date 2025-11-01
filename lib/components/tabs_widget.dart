import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class TabsWidget extends StatelessWidget {
  const TabsWidget({
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Container(height: 4, color: context.resources.color.background2),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ...tabs.map((tab) {
                return Expanded(
                  flex: 1,
                  child: Row(
                    children: [

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            onSelect(tab);
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: selectedTab == tab.toString()
                                  ? context.resources.color.colorPrimary
                                  : context.resources.color.colorWhite,
                            ),
                            child: Center(
                              child: PrimaryText(
                                textAlign: TextAlign.center,
                                text: tab.toString(),
                                textColor: selectedTab == tab.toString()
                                    ? context.resources.color.colorWhite
                                    : context.resources.color.colorGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        width: .5,
                        height: 20,
                        color: context.resources.color.colorGrey,
                      )

                    ],
                  ),
                );
              }),
            ],
          ),

          Container(height: 8, color: context.resources.color.background2),
        ],
      ),
    );
  }
}
