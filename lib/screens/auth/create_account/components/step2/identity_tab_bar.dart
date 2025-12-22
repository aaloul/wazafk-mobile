import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class IdentityTabBar extends StatelessWidget {
  const IdentityTabBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.resources.color.colorGrey4,
        borderRadius: BorderRadius.circular(120),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                onSelect("personal_id");
              },
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: selected == "personal_id"
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorGrey4,
                  borderRadius: BorderRadius.circular(120),
                ),
                child: Center(
                  child: PrimaryText(
                    text: Resources.of(context).strings.personalId,
                    fontWeight: FontWeight.w500,
                    textColor: selected == "personal_id"
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
              onTap: () {
                onSelect("passport");
              },
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: selected != "personal_id"
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorGrey4,
                  borderRadius: BorderRadius.circular(120),
                ),
                child: Center(
                  child: PrimaryText(
                    text: Resources.of(context).strings.passport,
                    fontWeight: FontWeight.w500,
                    textColor: selected != "personal_id"
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
