import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../model/ConversationMessagesResponse.dart';
import '../conversation_messages_controller.dart';
import 'direct_message_item.dart';

class MessagesWidget extends StatelessWidget {
  MessagesWidget({super.key});

  final ConversationMessagesController dataController = Get.put(
    ConversationMessagesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dataController.grouped.value.keys.length,
          itemBuilder: (context, index) {
            String date = dataController.grouped.keys.toList()[index];
            List<ConversationMessage> messages =
                dataController.grouped[date] ?? [];
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: context.resources.color.colorGrey4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PrimaryText(
                      text: date,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      textColor: context.resources.color.colorBlack3,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: context.resources.color.colorGrey4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return DirectMessage(message: messages[index]);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
