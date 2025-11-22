import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/CoversationsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
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
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(99999999),
              child: PrimaryNetworkImage(
                url: conversation.image.toString(),
                width: 60,
                height: 60,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: HexColor('#99999980').withOpacity(.5),
              margin: EdgeInsets.symmetric(horizontal: 12),
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
                          fontWeight: hasUnreadMessage
                              ? FontWeight.w700
                              : FontWeight.w600,
                          textColor: context.resources.color.colorGrey23,
                          fontSize: 16,
                        ),
                      ),
                      if (lastMessageTime.isNotEmpty)
                        PrimaryText(
                          text: lastMessageTime,
                          fontSize: 12,
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
                              'No messages yet',
                          fontSize: 14,
                          textColor: hasUnreadMessage
                              ? context.resources.color.colorGrey23
                              : context.resources.color.colorGrey23.withOpacity(
                                  0.7,
                                ),
                          fontWeight: hasUnreadMessage
                              ? FontWeight.w500
                              : FontWeight.normal,
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
    );
  }
}
