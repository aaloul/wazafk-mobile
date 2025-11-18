import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/NotificationsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class NotificationDetailsSheet {
  static Future<void> show(
    BuildContext context, {
    required NotificationElement notification,
    VoidCallback? onMarkAsRead,
    VoidCallback? onActionPressed,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.resources.color.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Drag indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.resources.color.colorGrey4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  PrimaryText(
                    text: notification.title.toString().isNotEmpty
                        ? notification.title.toString()
                        : 'Notification Details',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorGrey,
                  ),

                  SizedBox(height: 16),

                  PrimaryText(
                    text: notification.message ?? 'No message',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey,
                    maxLines: 50,
                  ),

                  SizedBox(height: 16),

                  PrimaryText(
                    text: notification.datetime != null
                        ? DateFormat(
                            'MMM dd, yyyy - hh:mm a',
                          ).format(notification.datetime!)
                        : 'Unknown',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey19,
                  ),

                  SizedBox(height: 24),

                  // Action Buttons
                  PrimaryButton(
                    title: "Close",
                    onPressed: () {
                      Navigator.pop(context);
                      onMarkAsRead?.call();
                    },
                    color: context.resources.color.colorPrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
