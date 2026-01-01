import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/SupportConversationsResponse.dart';
import 'package:wazafak_app/screens/chat/components/participants_avatar_grid.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class SupportConversationListItem extends StatelessWidget {
  const SupportConversationListItem({
    super.key,
    required this.conversation,
    required this.conversationName,
    required this.lastMessageTime,
    this.onTap,
  });

  final SupportConversation conversation;
  final String conversationName;
  final String lastMessageTime;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = conversation.status == 0;
    final statusColor = isActive
        ? context.resources.color.colorGreen
        : context.resources.color.colorGrey;
    final isDispute = conversation.reference == 'DISPUTE';

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
            // Avatar: Participants grid for disputes, support icon for support
            isDispute
                ? ParticipantsAvatarGrid(
                    participants: conversation.groupParticipants ?? [],
                    size: 60,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: context.resources.color.colorPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.support_agent,
                      color: context.resources.color.colorPrimary,
                      size: 32,
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
                          text: conversation.subject ?? Resources.of(context).strings.supportTicket,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorGrey23,
                          fontSize: 16,
                          maxLines: 1,
                        ),
                      ),
                      if (lastMessageTime.isNotEmpty)
                        PrimaryText(
                          text: lastMessageTime,
                          fontSize: 12,
                          textColor:
                              context.resources.color.colorGrey23.withOpacity(
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
                          text: conversation.categoryName ?? Resources.of(context).strings.generalSupport,
                          fontSize: 14,
                          textColor:
                              context.resources.color.colorGrey23.withOpacity(
                            0.7,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: PrimaryText(
                          text: isActive ? Resources.of(context).strings.active : Resources.of(context).strings.closed,
                          fontSize: 12,
                          textColor: statusColor,
                          fontWeight: FontWeight.w500,
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
