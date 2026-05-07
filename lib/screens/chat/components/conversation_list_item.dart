import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/CoversationsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class ConversationListItem extends StatelessWidget {
  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.conversationName,
    required this.lastMessageTime,
    this.onTap,
  });

  final Coversation conversation;
  final String conversationName;
  final String lastMessageTime;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasUnreadMessage = conversation.lastMessage?.read == 0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(99999999),
              child: PrimaryNetworkImage(
                url: conversation.image.toString(),
                width: 45,
                height: 45,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: PrimaryText(
                          text: conversationName,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorGrey26,
                          fontSize: 12,
                        ),
                      ),
                      if (lastMessageTime.isNotEmpty)
                        PrimaryText(
                          text: lastMessageTime,
                          fontSize: 12,
                          fontWeight: hasUnreadMessage
                              ? FontWeight.w600
                              : FontWeight.w400,
                          textColor: hasUnreadMessage
                              ? context.resources.color.colorPrimary
                              : context.resources.color.colorGrey23.withOpacity(
                                  0.6,
                                ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryText(
                          text:
                              conversation.lastMessage?.message ??
                              Resources.of(context).strings.noMessagesYet,
                          fontSize: 14,
                          textColor: hasUnreadMessage
                              ? context.resources.color.colorGrey26
                              : context.resources.color.colorGrey26.withOpacity(
                                  0.7,
                                ),
                          fontWeight: hasUnreadMessage
                              ? FontWeight.w600
                              : FontWeight.w400,
                          maxLines: 2,
                        ),
                      ),
                      if (hasUnreadMessage)
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: context.resources.color.colorPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
          Divider(
            height: 1,
            thickness: 1,
            color: HexColor('#E9E9E9'),
          ),
        ],
      ),
    );
  }
}
