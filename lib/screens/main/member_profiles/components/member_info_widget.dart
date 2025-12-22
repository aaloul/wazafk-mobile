import 'package:flutter/material.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_text.dart';
import '../../../../utils/res/AppIcons.dart';

class MemberInfoWidget extends StatelessWidget {
  const MemberInfoWidget({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: 'About',
            fontSize: 16,
            fontWeight: FontWeight.w900,
            textColor: context.resources.color.colorGrey,
          ),

          SizedBox(height: 4),

          PrimaryText(
            text: user.info.toString().isEmpty
                ? context.resources.strings.notAvailable
                : user.info ?? context.resources.strings.notAvailable,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: context.resources.color.colorGrey,
          ),

          SizedBox(height: 12),

          //
          // Row(
          //   children: [
          //     Image.asset(
          //       AppIcons.location,
          //       width: 20,
          //       color: context.resources.color.colorGrey,
          //     ),
          //     SizedBox(width: 6),
          //     PrimaryText(
          //       text: "N/A",
          //       textColor: context.resources.color.colorGrey,
          //     ),
          //   ],
          // ),
          //
          // SizedBox(height: 6),
          Row(
            children: [
              Image.asset(
                AppIcons.calendar,
                width: 20,
                color: context.resources.color.colorGrey,
              ),
              SizedBox(width: 6),
              PrimaryText(
                text: 'Member Since ${user.joinYear}',
                textColor: context.resources.color.colorGrey,
              ),
            ],
          ),
          SizedBox(height: 8),

          Row(
            children: [
              Image.asset(
                AppIcons.link,
                width: 20,
                color: context.resources.color.colorGrey,
              ),
              SizedBox(width: 6),
              PrimaryText(
                text: user.website.toString() == 'null'
                    ? 'N/A'
                    : user.website ?? 'N/A',
                textColor: context.resources.color.colorGrey,
              ),
            ],
          ),

          Container(
            width: double.infinity,
            height: 1,
            color: context.resources.color.colorGrey.withOpacity(.25),
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          ),
        ],
      ),
    );
  }
}
