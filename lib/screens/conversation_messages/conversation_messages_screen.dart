import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/screens/conversation_messages/conversation_messages_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../components/primary_text_field.dart';
import '../../components/top_header.dart';
import '../../utils/res/AppIcons.dart';
import 'components/messages_shimmer.dart';
import 'components/messages_widget.dart';

class ConversationMessagesScreen extends StatefulWidget {
  const ConversationMessagesScreen({super.key});

  @override
  State<ConversationMessagesScreen> createState() =>
      _ConversationMessagesScreenState();
}

class _ConversationMessagesScreenState
    extends State<ConversationMessagesScreen> {
  final ConversationMessagesController dataController = Get.put(
    ConversationMessagesController(),
  );

  String customerHashcode = Get.arguments['member_hashcode'].toString();
  String customerName = Get.arguments['member_name'].toString();

  @override
  void initState() {
    dataController.customerHashcode = customerHashcode;

    dataController.getMessages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(children: [TopHeader(title: customerName)]),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(
                () =>
                    dataController.isMessagesLoading.value ||
                        dataController.isDataLoading.value
                    ? const MessagesShimmer()
                    : SingleChildScrollView(
                        controller: dataController.scrollController,
                        child: Column(children: [MessagesWidget()]),
                      ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 1,
                  color: context.resources.color.colorGrey4,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: context.resources.color.background2,
                            borderRadius: BorderRadius.circular(36),
                            border: Border.all(
                              color: context.resources.color.background2,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: PrimaryTextField(
                                  controller: dataController.messageController,
                                  hint: "Message",
                                  borderRadius: 36,
                                  borderColor:
                                      context.resources.color.background2,
                                  backgroundColor:
                                      context.resources.color.background2,
                                  inputType: TextInputType.text,
                                ),
                              ),

                              Container(
                                width: 1,
                                height: 28,
                                color: context.resources.color.colorGrey10,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                              ),
                              GestureDetector(
                                onTap: () {
                                  dataController.sendMessages();
                                },
                                child: Image.asset(
                                  AppIcons.send,
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ),

                      // Image.asset(
                      //   AppIcons.addChat,
                      //   width: 42,
                      //   height: 42,
                      // ),
                      // const SizedBox(
                      //   width: 8,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    Get.delete<ConversationMessagesController>();

    await dataController.pusher.unsubscribe(
      channelName: dataController.channelName,
    );
    super.dispose();
  }
}
