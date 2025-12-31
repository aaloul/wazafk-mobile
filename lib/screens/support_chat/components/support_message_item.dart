import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/SupportConversationMessagesResponse.dart';
import 'package:wazafak_app/screens/support_chat/components/support_message_attachment_widget.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/utils.dart';

class SupportMessageItem extends StatelessWidget {
  const SupportMessageItem({super.key, required this.message});

  final SupportConversationMessage message;

  @override
  Widget build(BuildContext context) {
    // Member messages on the right, Support messages on the left
    bool isMemberMessage = message.senderType == 'M';

    return isMemberMessage
        ? Container(
            margin: Utils().isRTL()
                ? const EdgeInsets.only(right: 90, bottom: 8)
                : const EdgeInsets.only(left: 90, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Utils().isRTL()
                          ? const Radius.circular(0)
                          : const Radius.circular(8),
                      topRight: Utils().isRTL()
                          ? const Radius.circular(8)
                          : const Radius.circular(0),
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Attachment
                      if (message.hasAttachment)
                        SupportMessageAttachmentWidget(
                          message: message,
                          isSentByMe: true,
                        ),
                      if (message.hasAttachment &&
                          message.message != null &&
                          message.message!.isNotEmpty)
                        SizedBox(height: 8),
                      // Text message
                      if (message.message != null && message.message!.isNotEmpty)
                        PrimaryText(
                          text: message.message.toString(),
                          textColor: Colors.white,
                          fontSize: 14,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Utils().isRTL()
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
                  child: PrimaryText(
                    text: DateFormat('hh:mma').format(message.createdAt!),
                    fontSize: 12,
                    textColor: context.resources.color.colorBlack3,
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: Utils().isRTL()
                ? const EdgeInsets.only(left: 90, bottom: 8)
                : const EdgeInsets.only(right: 90, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Support agent name if available
                if (message.memberFirstName != null ||
                    message.memberLastName != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: PrimaryText(
                      text:
                          '${message.memberFirstName ?? ''} ${message.memberLastName ?? ''}'.trim(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: context.resources.color.colorGrey,
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: context.resources.color.colorGrey4,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Utils().isRTL()
                          ? const Radius.circular(0)
                          : const Radius.circular(8),
                      topLeft: Utils().isRTL()
                          ? const Radius.circular(8)
                          : const Radius.circular(0),
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Attachment
                      if (message.hasAttachment)
                        SupportMessageAttachmentWidget(
                          message: message,
                          isSentByMe: false,
                        ),
                      if (message.hasAttachment &&
                          message.message != null &&
                          message.message!.isNotEmpty)
                        SizedBox(height: 8),
                      // Text message
                      if (message.message != null && message.message!.isNotEmpty)
                        PrimaryText(
                          text: message.message.toString(),
                          textColor: context.resources.color.colorBlack,
                          fontSize: 14,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Utils().isRTL()
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: PrimaryText(
                    text: DateFormat(
                      'hh:mma',
                    ).format(message.createdAt!),
                    fontSize: 12,
                    textColor: context.resources.color.colorBlack3,
                  ),
                ),
              ],
            ),
          );
  }
}
