import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../model/ConversationMessagesResponse.dart';

class DirectMessage extends StatelessWidget {
  const DirectMessage({super.key, required this.message});

  final ConversationMessage message;

  @override
  Widget build(BuildContext context) {
    return message.senderHashcode.toString() == Prefs.getId
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
                  child: PrimaryText(
                    text: message.message.toString(),
                    textColor: Colors.white,
                    fontSize: 14,
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
        : GestureDetector(
            onTap: () {
              // if(message.senderHashcode.toString() != Prefs.getUserId){
              //   Get.toNamed(RouteConstant.customerProfileScreen,
              //       arguments: {
              //         'name': '',
              //         'id':message.senderHashcode.toString()
              //       }
              //   );
              // }else{
              //   Get.toNamed(RouteConstant.customerProfileScreen,
              //       arguments: {
              //         'name': '',
              //         'id':message.receiverHashcode.toString()
              //       }
              //   );
              // }
            },
            child: Container(
              margin: Utils().isRTL()
                  ? const EdgeInsets.only(left: 40, bottom: 8)
                  : const EdgeInsets.only(right: 40, bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999999),
                    child: PrimaryNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      url: message.senderHashcode.toString() == Prefs.getId
                          ? message.receiverPhoto.toString()
                          : message.senderPhoto.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                          child: PrimaryText(
                            text: message.message.toString(),
                            textColor: context.resources.color.colorBlack,
                            fontSize: 14,
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
                  ),
                ],
              ),
            ),
          );
  }
}
