import 'package:flutter/material.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import 'components/invite_friend_item.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Invite a Friend'),
            SizedBox(height: 16),

            InviteFriendItem(
              title: 'By e-mail Address',
              onClick: () {},
              color: HexColor("#CDE9EE"),
              border: HexColor("#CDE9EE"),
              icon: AppIcons.whatsapp,
            ),

            SizedBox(height: 10),
            InviteFriendItem(
              title: 'By WhatsApp',
              onClick: () {},
              color: HexColor("#E7F3EE"),
              border: HexColor("#E7F3EE"),
              icon: AppIcons.email,
            ),
          ],
        ),
      ),
    );
  }
}
