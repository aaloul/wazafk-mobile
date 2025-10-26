import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_text.dart';
import '../../../../model/MemberProfileResponse.dart';

class MemberInfoHeader extends StatelessWidget {
  const MemberInfoHeader({super.key, required this.memberProfile});

  final MemberProfile memberProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrimaryText(
                text: '${memberProfile.member?.nbCompletedJobs ?? '0'}',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                textColor: context.resources.color.colorGrey,
              ),
              SizedBox(height: 2),
              PrimaryText(
                text: 'Completed Jobs',
                fontSize: 13,
                textColor: context.resources.color.colorGrey,
              ),
            ],
          ),
        ),

        Container(
          width: .7,
          height: 28,
          color: context.resources.color.colorGrey,
        ),

        Expanded(
          flex: 2,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrimaryText(
                text: '${memberProfile.member?.rating}',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                textColor: context.resources.color.colorGrey,
              ),
              SizedBox(height: 2),
              PrimaryText(
                text: 'Rating',
                fontSize: 13,
                textColor: context.resources.color.colorGrey,
              ),
            ],
          ),
        ),

        Container(
          width: .7,
          height: 28,
          color: context.resources.color.colorGrey,
        ),

        Expanded(
          flex: 3,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PrimaryText(
                text: '${memberProfile.member?.nbJobPosts ?? '0'}',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                textColor: context.resources.color.colorGrey,
              ),
              SizedBox(height: 2),
              PrimaryText(
                text: 'Services',
                fontSize: 13,
                textColor: context.resources.color.colorGrey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
