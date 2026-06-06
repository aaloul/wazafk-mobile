import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/DocumentsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

enum DocStatus { upload, pending, verified, rejected }

class MyDocumentItem extends StatelessWidget {
  const MyDocumentItem({
    super.key,
    required this.document,
    required this.onClick,
  });

  final Document document;
  final VoidCallback onClick;

  /// Backend `status` numeric mapping. 0/null = no document uploaded (Upload
  /// CTA), 1 = pending review, 2 = verified, -1 = rejected.
  DocStatus get _status {
    final s = document.status;
    final hasDoc =
        (document.document1?.isNotEmpty ?? false) ||
            (document.document2?.isNotEmpty ?? false);
    if (s == null && !hasDoc) return DocStatus.upload;
    if (s == 2) return DocStatus.verified;
    if (s == -1) return DocStatus.rejected;
    if (s == 0 && !hasDoc) return DocStatus.upload;
    return DocStatus.pending;
  }

  String _iconAsset() {
    final t = (document.type ?? '').toLowerCase();
    if (t.contains('passport')) return AppIcons.docPassport;
    return AppIcons.docIdCard;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                _iconAsset(),
                fit: BoxFit.contain,
                color: colors.colorPrimary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: PrimaryText(
                text: document.type ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: colors.colorBlack,
              ),
            ),
            _StatusBadge(status: _status),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final DocStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    switch (status) {
      case DocStatus.upload:
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: colors.colorPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: PrimaryText(
            text: strings.uploadDoc,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            textColor: colors.colorWhite,
          ),
        );
      case DocStatus.pending:
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: colors.colorPrimaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: PrimaryText(
            text: strings.pending,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            textColor: colors.colorPrimary,
          ),
        );
      case DocStatus.verified:
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: colors.colorGreen5,
            borderRadius: BorderRadius.circular(8),
          ),
          child: PrimaryText(
            text: strings.docVerified,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            textColor: colors.colorGreen6,
          ),
        );
      case DocStatus.rejected:
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: colors.colorRed2.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PrimaryText(
            text: strings.rejected,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            textColor: colors.colorRed2,
          ),
        );
    }
  }
}
