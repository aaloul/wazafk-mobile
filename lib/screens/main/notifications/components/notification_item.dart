import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/NotificationsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    this.onAccept,
    this.onDecline,
    this.isProcessing = false,
  });

  final NotificationElement notification;
  final VoidCallback onTap;

  /// When non-null, an inline Accept/Decline action row is rendered.
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final bool isProcessing;

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
    final showActions = onAccept != null && onDecline != null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: notification.title ?? '',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    textColor: context.resources.color.colorBlack,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  PrimaryText(
                    text: notification.message ?? '',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.35,
                    textColor: context.resources.color.colorGrey26,
                    maxLines: 4,
                  ),
                  if (showActions) ...[
                    const SizedBox(height: 12),
                    _buildActions(context),
                  ],
                  const SizedBox(height: 6),
                  PrimaryText(
                    text: _getTimeAgo(notification.datetime),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    textColor: context.resources.color.colorGrey29,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnread
                      ? HexColor('#E55959')
                      : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final strings = Resources.of(context).strings;
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: strings.accept,
            color: HexColor('#7CB68E'),
            isLoading: isProcessing,
            onTap: isProcessing ? null : onAccept,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            label: strings.decline,
            color: HexColor('#E96A6A'),
            isLoading: false,
            onTap: isProcessing ? null : onDecline,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: disabled ? color.withValues(alpha: 0.6) : color,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : PrimaryText(
                text: label,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
              ),
      ),
    );
  }
}
