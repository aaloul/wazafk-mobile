import 'package:flutter/material.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_text.dart';
import '../../../../utils/res/AppIcons.dart';

class MemberInfoWidget extends StatelessWidget {
  const MemberInfoWidget({super.key, required this.user});

  final User user;

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Member since card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: _cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    AppIcons.since,
                    width: 20,
                  ),
                  SizedBox(width: 6),
                  PrimaryText(
                    text: context.resources.strings.memberSince(user.joinYear ?? ''),
                    textColor: context.resources.color.colorGrey,
                  ),
                ],
              ),
              if(user.website != null)
                SizedBox(height: 8),
              if(user.website != null)
              Row(
                children: [
                  Image.asset(
                    AppIcons.link,
                    width: 20,
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
            ],
          ),
        ),

        // About card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: _cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                text: context.resources.strings.about,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: context.resources.color.colorBlack4,
              ),
              SizedBox(height: 8),
              PrimaryText(
                text: user.info.toString().isEmpty
                    ? context.resources.strings.notAvailable
                    : user.info ?? context.resources.strings.notAvailable,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: context.resources.color.colorGrey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
