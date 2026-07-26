import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/model/SkillsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

class AddSkillArgs {
  const AddSkillArgs({
    required this.availableSkills,
    required this.selectedSkills,
    required this.freeSkills,
    required this.maxSkills,
    required this.extraSkillPrice,
    required this.step,
    required this.totalSteps,
    required this.onContinue,
    this.isLoadingSkills = false,
    this.title,
  });

  final List<Skill> availableSkills;
  final List<Skill> selectedSkills;
  final int freeSkills;
  final int maxSkills;
  final double extraSkillPrice;
  final int step;
  final int totalSteps;

  /// Receives the picked skills in selection order — the first [freeSkills] of
  /// them are the free ones.
  final ValueChanged<List<Skill>> onContinue;

  final bool isLoadingSkills;
  final String? title;
}

/// "Add Skill 2 / 3" (design p181) — pick the skills carried by a service; the
/// first one is free and each extra is a one-time charge.
class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  late final AddSkillArgs args;
  late List<Skill> selected;

  @override
  void initState() {
    super.initState();
    args = Get.arguments as AddSkillArgs;
    selected = List<Skill>.of(args.selectedSkills);
  }

  void _toggle(Skill skill) {
    final index = selected.indexWhere((s) => s.hashcode == skill.hashcode);
    if (index >= 0) {
      setState(() => selected.removeAt(index));
      return;
    }
    if (selected.length >= args.maxSkills) {
      constants.showSnackBar(
        context.resources.strings.maxSkillsReached(args.maxSkills),
        SnackBarStatus.ERROR,
      );
      return;
    }
    setState(() => selected.add(skill));
  }

  double get _extraCost =>
      selected.length > args.freeSkills
          ? (selected.length - args.freeSkills) * args.extraSkillPrice
          : 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
              hasBack: true,
              title: args.title ?? strings.addSkill,
              endWidget: PrimaryText(
                text: '${args.step} / ${args.totalSteps}',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textColor: colors.colorGrey,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _priceNote(context),
                    const SizedBox(height: 16),
                    _SelectionSummary(
                      selectedCount: selected.length,
                      maxSkills: args.maxSkills,
                      extraCost: _extraCost,
                    ),
                    const SizedBox(height: 18),
                    if (args.isLoadingSkills)
                      Center(child: ProgressBar())
                    else if (args.availableSkills.isEmpty)
                      PrimaryText(
                        text: strings.noSkillsAvailableForCategory,
                        fontSize: 14,
                        textColor: colors.colorGrey8,
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: args.availableSkills.map((skill) {
                          final index = selected.indexWhere(
                            (s) => s.hashcode == skill.hashcode,
                          );
                          return _SkillChip(
                            label: skill.name ?? '',
                            state: index < 0
                                ? _SkillChipState.unselected
                                : index < args.freeSkills
                                    ? _SkillChipState.free
                                    : _SkillChipState.paid,
                            price: args.extraSkillPrice,
                            onTap: () => _toggle(skill),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _ReachCard(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PrimaryButton(
                title: strings.continueBtn,
                onPressed: () => args.onContinue(List<Skill>.of(selected)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// "First **skill for free**. Each extra skill = **$1**, one-time." — the
  /// translated sentence marks its bold parts with `{b}…{/b}`.
  Widget _priceNote(BuildContext context) {
    final colors = context.resources.color;
    final price = args.extraSkillPrice;
    final priceText = price == price.roundToDouble()
        ? '\$${price.toStringAsFixed(0)}'
        : '\$${price.toStringAsFixed(2)}';
    final note = context.resources.strings.firstSkillFreeNote(priceText);

    final base = TextStyle(
      fontFamily: 'SF Pro Text',
      fontSize: 14,
      height: 1.3,
      color: colors.colorBlack4,
    );

    var isBold = false;
    final spans = <TextSpan>[];
    for (final part in note.split(RegExp(r'\{/?b\}'))) {
      if (part.isNotEmpty) {
        spans.add(
          TextSpan(
            text: part,
            style: isBold ? const TextStyle(fontWeight: FontWeight.w700) : null,
          ),
        );
      }
      isBold = !isBold;
    }

    return RichText(text: TextSpan(style: base, children: spans));
  }
}

/// SELECTED n / max + EXTRA COST + progress bar (design p181).
class _SelectionSummary extends StatelessWidget {
  const _SelectionSummary({
    required this.selectedCount,
    required this.maxSkills,
    required this.extraCost,
  });

  final int selectedCount;
  final int maxSkills;
  final double extraCost;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final progress = maxSkills == 0
        ? 0.0
        : (selectedCount / maxSkills).clamp(0.0, 1.0).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: BoxDecoration(
        color: colors.colorPrimaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.colorPrimary.withAlpha(90)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrimaryText(
                text: strings.selectedCaps,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                textColor: colors.colorPrimary,
              ),
              PrimaryText(
                text: strings.extraCostCaps,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                textColor: colors.colorPrimary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  PrimaryText(
                    text: '$selectedCount',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: colors.colorPrimary,
                  ),
                  PrimaryText(
                    text: ' / $maxSkills',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    textColor: colors.colorGrey26,
                  ),
                ],
              ),
              PrimaryText(
                text: '+ \$${extraCost.toStringAsFixed(0)}',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: colors.colorPrimary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colors.colorWhite,
              valueColor: AlwaysStoppedAnimation(colors.colorPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

enum _SkillChipState { unselected, free, paid }

class _SkillChip extends StatelessWidget {
  const _SkillChip({
    required this.label,
    required this.state,
    required this.price,
    required this.onTap,
  });

  final String label;
  final _SkillChipState state;
  final double price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final isFree = state == _SkillChipState.free;
    final isPaid = state == _SkillChipState.paid;
    final isSelected = isFree || isPaid;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isFree ? colors.colorPrimary : colors.colorWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? colors.colorPrimary : colors.colorGrey29,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryText(
              text: isSelected ? label : '+ $label',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: isFree
                  ? colors.colorWhite
                  : isPaid
                      ? colors.colorPrimary
                      : colors.colorGrey26,
            ),
            if (isFree) ...[
              const SizedBox(width: 8),
              Image.asset(AppIcons.checkWhite, width: 16),
            ],
            if (isPaid) ...[
              const SizedBox(width: 8),
              PrimaryText(
                text: '\$${price.toStringAsFixed(0)}',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: colors.colorPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "More skills = Wider reach" card above the button (design p181).
class _ReachCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.colorGrey25),
      ),
      child: Row(
        children: [
          Image.asset(AppIcons.moreSkills, width: 92),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryText(
              text: context.resources.strings.moreSkillsWiderReach,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              textColor: colors.colorBlack4,
            ),
          ),
        ],
      ),
    );
  }
}
