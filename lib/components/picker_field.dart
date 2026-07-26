import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Bordered, tappable field used by the post/service forms for picker inputs —
/// areas, start date, start time (design p185 / p112). Shows [hint] until
/// [value] is set.
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.hint,
    required this.value,
    required this.trailing,
    required this.onTap,
    this.enabled = true,
  });

  final String hint;
  final String? value;
  final Widget trailing;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.colorGrey25),
        ),
        child: Row(
          children: [
            Expanded(
              child: PrimaryText(
                text: hasValue ? value! : hint,
                fontSize: 14,
                fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                // A picked value reads in the app's primary colour.
                textColor: hasValue ? colors.colorPrimary : colors.colorGrey8,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}
