import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/SupportConversationMessagesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../support_chat_controller.dart';
import 'support_message_item.dart';

class SupportMessagesWidget extends StatelessWidget {
  SupportMessagesWidget({super.key});

  final SupportChatController dataController = Get.find<SupportChatController>();

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
            List<SupportConversationMessage> messages =
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
                    return SupportMessageItem(message: messages[index]);
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
