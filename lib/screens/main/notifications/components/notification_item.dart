import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/NotificationsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationElement notification;
  final VoidCallback onTap;

  String _getTimeAgo(DateTime? datetime) {
    if (datetime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(datetime);

    if (difference.inDays > 7) {
      return DateFormat('MMM dd, yyyy').format(datetime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.isRead == 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(color: context.resources.color.colorWhite),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 70,
              height: 70,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.resources.color.colorGrey21,
                shape: BoxShape.circle,
              ),
              child: Image.asset(AppIcons.notification2),
            ),

            Container(
              width: 1,
              height: 50,
              color: HexColor('#99999980').withOpacity(.5),
              margin: EdgeInsets.symmetric(horizontal: 12),
            ),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryText(
                    text: notification.title ?? '',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey,
                    maxLines: 2,
                  ),

                  SizedBox(height: 4),

                  PrimaryText(
                    text: notification.message ?? '',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    textColor: context.resources.color.colorGrey3,
                    maxLines: 3,
                  ),

                  SizedBox(height: 8),
                  PrimaryText(
                    text: _getTimeAgo(notification.datetime),
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    textColor: context.resources.color.colorGrey19,
                  ),
                ],
              ),
            ),

            if (isUnread)
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: context.resources.color.colorPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
