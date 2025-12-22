import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.message,
    this.showRetry = false,
    this.onRetry,
    this.icon,
  });

  final String message;
  final bool showRetry;
  final VoidCallback? onRetry;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, size: 64, color: context.resources.color.colorGrey3),
          if (icon != null) SizedBox(height: 16),
          PrimaryText(
            text: message,
            textColor: context.resources.color.colorGrey3,
            fontSize: 16,
            textAlign: TextAlign.center,
          ),
          if (showRetry && onRetry != null) ...[
            SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: context.resources.color.colorPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PrimaryText(
                  text: Resources.of(context).strings.retry,
                  textColor: context.resources.color.colorWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
