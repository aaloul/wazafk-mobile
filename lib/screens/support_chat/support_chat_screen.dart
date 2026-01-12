import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/dialog/dialog_helper.dart';
import 'package:wazafak_app/components/sheets/attachment_options_bottom_sheet.dart';
import 'package:wazafak_app/screens/conversation_messages/widgets/attachment_preview_widget.dart';
import 'package:wazafak_app/screens/conversation_messages/widgets/voice_recording_widget.dart';
import 'package:wazafak_app/screens/support_chat/support_chat_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../components/primary_text_field.dart';
import '../../components/top_header.dart';
import '../../model/SupportConversationsResponse.dart';
import '../../utils/res/AppIcons.dart';
import '../../utils/res/Resources.dart';
import '../conversation_messages/components/messages_shimmer.dart';
import 'components/support_messages_widget.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final SupportChatController dataController = Get.put(
    SupportChatController(),
  );

  late SupportConversation conversation;

  @override
  void initState() {
    conversation = Get.arguments as SupportConversation;
    dataController.conversation = conversation;
    dataController.conversationHashcode = conversation.hashcode ?? '';

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
              child: Column(children: [
                TopHeader(
                  title: conversation.subject ??
                      context.resources.strings.contactSupport,
                  endWidget: conversation.reference == 'DISPUTE'
                      ? null
                      : Obx(() => dataController.isEndingConversation.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.resources.color.colorPrimary,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _showEndConversationDialog(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: context.resources.color.colorPrimary,
                                size: 24,
                              ),
                            )),
                )
              ]),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(
                () => dataController.isMessagesLoading.value
                    ? const MessagesShimmer()
                    : SingleChildScrollView(
                        controller: dataController.scrollController,
                        child: Column(
                          children: [
                            // Loading indicator for pagination
                            Obx(() => dataController.isLoadingMore.value
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink()),
                            SupportMessagesWidget(),
                          ],
                        ),
                      ),
              ),
            ),
            Obx(
              () => dataController.isRecording.value
                  ? VoiceRecordingWidget(
                      onCancel: () {
                        dataController.cancelVoiceRecording();
                      },
                      onSend: () {
                        dataController.sendVoiceRecording();
                      },
                      recorderController: dataController.recorderController!,
                    )
                  : Column(
                      children: [
                        // Attachment preview
                        if (dataController.selectedAttachment.value != null)
                          AttachmentPreviewWidget(
                            file: dataController.selectedAttachment.value!,
                            attachmentType:
                                dataController.attachmentType.value ?? '',
                            fileName:
                                dataController.attachmentName.value ?? '',
                            onRemove: () {
                              dataController.removeAttachment();
                            },
                          ),
                        if(conversation.status.toString() == '0')
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: context.resources.color.colorGrey4,
                        ),
                        if(conversation.status.toString() == '0')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          color: Colors.white,
                          child: Row(
                            children: [
                              // Attachment button
                              GestureDetector(
                                onTap: () async {
                                  final type =
                                      await AttachmentOptionsBottomSheet.show(
                                          context);
                                  if (type != null) {
                                    dataController
                                        .handleAttachmentSelection(type);
                                  }
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: context.resources.color.colorPrimary
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.attach_file,
                                    color:
                                        context.resources.color.colorPrimary,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: context.resources.color.background2,
                                    borderRadius: BorderRadius.circular(36),
                                    border: Border.all(
                                      color:
                                          context.resources.color.background2,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: PrimaryTextField(
                                          controller:
                                              dataController.messageController,
                                          hint: Resources.of(context)
                                              .strings
                                              .message,
                                          borderRadius: 36,
                                          borderColor: context
                                              .resources.color.background2,
                                          backgroundColor: context
                                              .resources.color.background2,
                                          inputType: TextInputType.text,
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 28,
                                        color:
                                            context.resources.color.colorGrey10,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          dataController
                                              .sendMessageWithAttachment();
                                        },
                                        child:  Container(
                                          width: 30,
                                          height: 36,
                                          color: context
                                              .resources.color.background2,
                                          padding: EdgeInsets.all(3),
                                          child: Image.asset(
                                            AppIcons.send,
                                            width: 22,
                                            height: 22,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Voice recording button
                              GestureDetector(
                                onLongPressStart: (_) {
                                  dataController.startVoiceRecording();
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color:
                                        context.resources.color.colorPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _showEndConversationDialog(BuildContext context) {
    DialogHelper.showAgreementPopup(
      context,
      Resources.of(context).strings.areYouSureEndConversation,
      Resources.of(context).strings.confirm,
      Resources.of(context).strings.cancel,
      () {
        dataController.endConversation();
      },
      dataController.isEndingConversation,
      agreeColor: context.resources.color.colorRed,
    );
  }
}

