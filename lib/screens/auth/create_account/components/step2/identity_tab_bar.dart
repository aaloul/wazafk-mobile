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
      height: 52,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        border: Border.all(
          width: 1,
          color: context.resources.color.colorGrey25
        ),
        borderRadius: BorderRadius.circular(12),
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
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: selected == "personal_id"
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorWhite,
                  ),
                ),
                child: Center(
                  child: PrimaryText(
                    text: Resources.of(context).strings.personalId,
                    fontWeight:selected == "personal_id"
                        ? FontWeight.w500 :  FontWeight.w400,
                    textColor: selected == "personal_id"
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorGrey27,
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
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: selected != "personal_id"
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorWhite,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: PrimaryText(
                    text: Resources.of(context).strings.passport,
                    fontWeight: selected != "personal_id"
                        ?FontWeight.w500 :  FontWeight.w400,
                    textColor: selected != "personal_id"
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorGrey27,
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
