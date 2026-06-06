import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Section card with a bold title and a stack of toggle rows.
class NotifToggleCard extends StatelessWidget {
  const NotifToggleCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const SizedBox(height: 4),
          ...children,
        ],
      ),
    );
  }
}

/// "Label  ▶ [On/Off toggle]" row used inside NotifToggleCard.
class NotifToggleRow extends StatelessWidget {
  const NotifToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: PrimaryText(
              text: label,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: colors.colorBlack,
            ),
          ),
          _OnOffSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _OnOffSwitch extends StatelessWidget {
  const _OnOffSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 56,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? colors.colorPrimary : colors.colorGrey2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            Positioned(
              left: value ? 6 : null,
              right: value ? null : 6,
              child: PrimaryText(
                text: value ? 'On' : 'Off',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                textColor: colors.colorWhite,
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colors.colorWhite,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
