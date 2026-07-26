import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Chip used by the post/service forms for single-select rows — subcategories,
/// Location, Job Type (design p185 / p112): white pill with a light border,
/// blue tint + blue label when picked.
class FormChoiceChip extends StatelessWidget {
  const FormChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
    this.minWidth = 0,
    this.maxWidth = double.infinity,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  /// Floor for the chip width so short labels keep the same footprint as the
  /// longer ones in the row (design p185: ~80pt).
  final double minWidth;

  /// Ceiling for the chip width. Long labels ellipsize instead of claiming a
  /// whole row, so wrapped rows stay multi-column.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        // 38pt tall with 15pt side padding and a 10pt radius, per the Figma
        // measurements; centred so the label holds still if a parent row
        // stretches the chip.
        height: 38,
        constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: selected ? colors.colorPrimaryLight : colors.colorWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? colors.colorPrimary : colors.colorGrey25,
          ),
        ),
        child: PrimaryText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          maxLines: 1,
          textColor: selected ? colors.colorPrimary : colors.colorBlack,
        ),
      ),
    );
  }
}

/// Section label above a chip row / field — "Location", "Job Type *".
class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({
    super.key,
    required this.text,
    this.isMandatory = false,
  });

  final String text;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    return PrimaryText(
      text: isMandatory ? '$text*' : text,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      textColor: context.resources.color.colorGrey26,
    );
  }
}
